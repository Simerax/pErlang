package Erlang::Binary;
use Mouse;

extends 'Erlang::String';

sub equals {
    my ($self, $other) = @_;
    if (UNIVERSAL::isa($other, 'Erlang::Binary') && $other->data() eq $self->data()) {
        return 1;
    } else {
        return 0;
    }
}

1;
