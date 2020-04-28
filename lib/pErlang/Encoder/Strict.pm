package pErlang::Encoder::Strict;
use Mouse;
use utf8;
use pErlang::Type qw(:constants);

with qw(pErlang::Role::Encoder);

has data => (
    is => 'rw',
    isa => 'Str',
    default => '',
);


sub visit_pErlang_Integer {
    my ($self, $integer) = @_;

    my $encoded = $integer->subtype();
    if($integer->subtype() eq INTEGER_EXT) {
        $encoded .= pack('N!', $integer->value());
    } else {
        $encoded .= pack('C', $integer->value());
    }
    $self->data( $self->data() . $encoded);
}

sub visit_pErlang_Atom {
    my ($self, $atom) = @_;

    my $format;
    my $atom_str = "$atom";
    if($atom->subtype() eq ATOM_EXT || $atom->subtype() eq ATOM_UTF8_EXT) {
        $format = 'n';
    } else {
        $format = 'C';
    }

    if($atom->subtype() eq ATOM_UTF8_EXT || $atom->subtype() eq SMALL_ATOM_UTF8_EXT) {
        utf8::encode($atom_str);
    }

    my $encoded = $atom->subtype().pack($format, length($atom_str)).$atom_str;
    $self->data($self->data() . $encoded);
}

sub result {
    my($self) = @_;
    return $self->data();
}

sub reset {
    my($self) = @_;
    $self->data('');
}

1;
