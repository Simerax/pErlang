package pErlang::Binary;
use Mouse;

extends 'pErlang::String';

sub equals {
    my ($self, $other) = @_;
    if (UNIVERSAL::isa($other, 'pErlang::Binary') && $other->data() eq $self->data()) {
        return 1;
    } else {
        return 0;
    }
}

1;
