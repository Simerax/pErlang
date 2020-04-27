package pErlang::Binary;
use Mouse;
use pErlang::Type;

extends 'pErlang::String';

sub equals {
    my ($self, $other) = @_;
    if (UNIVERSAL::isa($other, 'pErlang::Binary') && $other->data() eq $self->data()) {
        return 1;
    } else {
        return 0;
    }
}

sub encode {
    my ($self) = @_;
    return pErlang::Type::BINARY_EXT.pack("N", $self->length()).$self->data();
}

1;
