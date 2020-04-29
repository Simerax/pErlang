package pErlang::Decode;
use warnings;
use strict;
use pErlang::Type qw(:all);
use pErlang::Atom;
use pErlang::Binary;
use pErlang::Integer;
use pErlang::Tuple;
use pErlang::Float;
use pErlang::List;
use pErlang::Nil;
use pErlang::Map;
use pErlang::String;

# if set then perl's 'read' function is used instead of 'sysread'
# sysread can't handle in-memory streams but guarantees to read the given byte size
# perl's read function can handle in-memory streams but might not read the correct amount of bytes
# and therefore might corrupt the given input
# https://github.com/Perl/perl5/issues/10125
our $USE_PERL_READ_FUNCTION = 0;

sub ret {
    return wantarray ? @_ : shift;
}

# decodes a message on given stream
sub decode {
    my ($stream) = @_;
    my $msg_prefix;
    sread($stream, \$msg_prefix, 1);
    if($msg_prefix ne "\x83") {
        return ret(0, "Invalid Message Prefix");
    }
    return decode_term($stream);
}

sub decode_term {
    my ($s, $next_item_type) = @_;

    while(1) {
        my $type;

        if(defined $next_item_type) {
            $type = $next_item_type;
        } else {
            my $read = sread($s, \$type, 1);
            if ($read <= 0) {
                return ret(0, "No Input");
            }
        }

        if(is_atom($type)) {
            my $len;
            my $subtype;
            if(is_atom_ext($type) || is_atom_utf8($type)) {
                sread($s, \$len, 2);
                $len = unpack("n", $len);
                $subtype = is_atom_utf8($type) ? pErlang::Type::ATOM_UTF8_EXT : pErlang::Type::ATOM_EXT;
            } elsif(is_atom_utf8_small($type)) {
                sread($s, \$len, 1);
                $len = unpack('C', $len);
                $subtype = pErlang::Type::SMALL_ATOM_UTF8_EXT;
            }
            my $atom_name;
            sread($s, \$atom_name, $len);
            my $atom = pErlang::Atom->new(
                name => $atom_name,
                subtype => $subtype,
            );
            return ret(1, $atom);
        } elsif(is_nil($type)) {
            my $nil = pErlang::Nil->new();
            return ret(1, $nil);
        } elsif(is_8bit_integer($type)) {
            my $int;
            sread($s, \$int, 1);
            $int = unpack('C', $int);
            my $pint = pErlang::Integer->new(
                value => $int,
                subtype => pErlang::Type::SMALL_INTEGER_EXT,
            );
            return ret(1, $pint);
        } elsif(is_32bit_integer($type)) {
            my $int;
            sread($s, \$int, 4);
            $int = unpack('N!', $int);
            my $pint = pErlang::Integer->new(
                value => $int,
                subtype => pErlang::Type::INTEGER_EXT,
            );
            return ret(1, $pint);
        } elsif(is_float($type)) {
            my $value;
            if (is_new_float($type)) {
                sread($s, \$value, 8);
                # FIXME: Is this portable? Perldoc says 'd' is native format
                # but '>' specifies the endianness
                $value = unpack('d>', $value); 

            } else {
                return ret(0, "Old Float Format not supported"); # TODO: Support old Float format
            }
            my $float = pErlang::Float->new(
                value => $value,
            );
            return ret(1, $float);
        } elsif(is_string($type)) { 
            my $len;
            sread($s, \$len, 2);
            $len = unpack("n", $len);
            my $data;
            sread($s, \$data, $len);
            my $string = pErlang::String->new(
                data => $data,
            );
            return ret(1, $string);
        } elsif(is_list($type)) {
            my $len;
            sread($s, \$len, 4);
            $len = unpack("N", $len);
            my @elements;
            for(1..$len) {
                my ($ok, $element) = decode_term($s);
                if($ok) {
                    push @elements, $element;
                } else {
                    return ret($ok, $element);
                }
            }

            my $list = pErlang::List->new(
                elements => \@elements,
                tail => pErlang::Nil->new(),
            );

            # a normal list has a tail of "NIL" but it doesn't have to be that way
            my $next_item_type;
            my $read = sread($s, \$next_item_type, 1);

            if($read > 0 && !is_nil($next_item_type)) { # looks like this list has a tail
                my ($ok, $elements) = decode_term($s, $next_item_type);
                if($ok) {
                    $list->tail($elements);
                } else {
                    return ret(0, $elements);
                }
            }
            return ret(1, $list);
        } elsif(is_tuple($type)) {
            my $arity;
            my $subtype;
            if(is_small_tuple($type)) {
                sread($s, \$arity, 1);
                $arity = unpack('C', $arity);
                $subtype = pErlang::Type::SMALL_TUPLE_EXT,
            } else {
                sread($s, \$arity, 4);
                $arity = unpack('N', $arity);
                $subtype = pErlang::Type::LARGE_TUPLE_EXT,
            }
            my @elements;
            for(1..$arity) {
                my ($ok, $element) = decode_term($s);
                if($ok) {
                    push @elements, $element;
                } else {
                    return ret($ok, $element);
                }
            }
            my $tuple = pErlang::Tuple->new(
                elements => \@elements,
                arity => $arity,
                subtype => $subtype,
            );
            return ret(1, $tuple);
        } elsif(is_map($type)) {
            my $arity;
            sread($s, \$arity, 4);
            $arity = unpack("N", $arity);
            my $map = pErlang::Map->new();
            for(my $i = 0; $i <= $arity; $i += 2) {
                my ($ok, $key) = decode_term($s);
                return ret(0, $key) unless $ok;
                my $value;
                ($ok, $value) = decode_term($s);
                return ret(0, $value) unless $ok;
                $map->put($key, $value);
            }
            return ret(1, $map);
        } elsif(is_binary($type)) {
            my $len;
            sread($s, \$len, 4);
            $len = unpack("N", $len);
            my $data;
            sread($s, \$data, $len);
            my $binary = pErlang::Binary->new(
                data => $data,
            );
            return ret(1, $binary);
        }
    }
}

sub sread {
    my($handle, $buffer_ref, $len) = @_;
    if($USE_PERL_READ_FUNCTION) {
        return read($handle, $$buffer_ref, $len);
    } else {
        return sysread($handle, $$buffer_ref, $len);
    }
}

1;
