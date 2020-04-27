package Erlang::String;
use Mouse;

extends 'Erlang::Datastructure';

use overload 
    '""' => \&to_string,
    '==' => \&equals,
    'eq' => \&string_equals;

has data => (
    is => 'rw',
    isa => 'Str',
    default => '',
);

sub length {
    return length($_[0]->data());
}

sub to_charlist {
    split('', $_[0]->data());
}

sub to_string {
    my ($self) = @_;
    return $self->data();
}

sub string_equals {
    my ($self, $other) = @_;
    return $self->data() eq $other;
}

sub equals {
    my ($self, $other) = @_;
    if (UNIVERSAL::isa($other, 'Erlang::String') && $other->data() eq $self->data()) {
        return 1;
    } else {
        return 0;
    }
}

1;
