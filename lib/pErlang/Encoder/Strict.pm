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

    my $encoded = $atom->subtype().pack($format, length($atom_str)).$atom_str;
    $self->data($self->data() . $encoded);
}

sub visit_pErlang_Nil {
    my ($self, $nil) = @_;
    $self->data($self->data() . NIL_EXT);
}

sub visit_pErlang_Binary {
    my ($self, $binary) = @_;
    $self->data( $self->data() . BINARY_EXT . pack("N", length($binary->data())).$binary->data());
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
