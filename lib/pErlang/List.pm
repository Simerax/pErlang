package pErlang::List;
use Mouse;

extends 'pErlang::Datastructure';

use pErlang::Nil;

has elements => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has tail => (
    is => 'rw',
    default => sub {pErlang::Nil->new()},
);

sub length {
    return scalar @{$_[0]->elements()};
}

sub at {
    return $_[0]->elements()->[$_[1]];
}

sub push {
    my ($self, $element) = @_;
    push @{$self->elements()}, $element;
}

1;
