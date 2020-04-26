package Erlang::Decode;
use Erlang::Type qw(:all);
use Erlang::Atom;
use Erlang::Binary;
use Erlang::Integer;
use Erlang::Tuple;

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
    my ($s) = @_;

    while(1) {
        my $type;
        sread($s, \$type, 1);
        if(is_atom($type)) {
            my $len;
            sread($s, \$len, 2);
            $len = unpack("n", $len);
            my $atom_name;
            sread($s, \$atom_name, $len);
            my $atom = Erlang::Atom->new(
                name => $atom_name,
                subtype => Erlang::Type::ATOM_EXT,
            );
            return ret(1, $atom);
        } elsif(is_8bit_integer($type)) {
            my $int;
            sread($s, \$int, 1);
            $int = unpack('C', $int);
            my $int = Erlang::Integer->new(
                value => $int,
                subtype => Erlang::Type::SMALL_INTEGER_EXT,
            );
            return ret(1, $int);
        } elsif(is_32bit_integer($type)) {
            my $int;
            sread($s, \$int, 4);
            $int = unpack('N!', $int);
            my $int = Erlang::Integer->new(
                value => $int,
                subtype => Erlang::Type::INTEGER_EXT,
            );
            return ret(1, $int);
        } elsif(is_tuple($type)) {
            my $arity;
            my $subtype;
            if(is_small_tuple($type)) {
                sread($s, \$arity, 1);
                $arity = unpack('C', $arity);
                $subtype = Erlang::Type::SMALL_TUPLE_EXT,
            } else {
                sread($s, \$arity, 4);
                $arity = unpack('N', $arity);
                $subtype = Erlang::Type::LARGE_TUPLE_EXT,
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
            my $tuple = Erlang::Tuple->new(
                elements => \@elements,
                arity => $arity,
                subtype => $subtype,
            );
            return ret(1, $tuple);
        } elsif(is_binary($type)) {
            my $len;
            sread($s, \$len, 4);
            $len = unpack("N", $len);
            my $data;
            sread($s, \$data, $len);
            my $binary = Erlang::Binary->new(
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
