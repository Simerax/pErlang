package pErlang::Encoder::Strict;
use Mouse;
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

sub result {
    my($self) = @_;
    return $self->data();
}

sub reset {
    my($self) = @_;
    $self->data('');
}

1;
