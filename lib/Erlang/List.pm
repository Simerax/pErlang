package Erlang::List;
use Mouse;

use Erlang::Nil;

has elements => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has tail => (
    is => 'rw',
    default => sub {Erlang::Nil->new()},
);

sub length {
    return scalar @{$_[0]->elements()};
}

sub at {
    return $_[0]->elements()->[$_[1]];
}

1;
