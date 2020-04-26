package Erlang::Binary;
use Mouse;

extends 'Erlang::Datastructure';

use overload
    'eq' => \&equals;

has data => (
    is => 'rw',
    isa => 'Str',
    default => '',
);

sub length {
    return length($_[0]->data());
}

sub equals {
    my ($self, $other) = @_;
    if(UNIVERSAL::isa($other, 'Erlang::Binary')) {
        return $self->data() eq $other->data();
    } else {
        return $self->data() eq $other;
    }
}

1;
