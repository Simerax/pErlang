package pErlang::String;
use Mouse;

extends 'pErlang::Datastructure';

use overload 
    '""' => \&to_string,
    '==' => \&equals,
    '!=' => \&not_equal,
    'eq' => \&string_equals,
    'ne' => \&string_not_equal;

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

sub string_not_equal {
    my ($self, $other) = @_;
    return !($self->string_equals($other));
}

sub equals {
    my ($self, $other) = @_;
    if (UNIVERSAL::isa($other, 'pErlang::String') && $other->data() eq $self->data()) {
        return 1;
    } else {
        return 0;
    }
}

sub not_equal {
    my ($self, $other) = @_;
    return !($self->equals($other));
}


1;
