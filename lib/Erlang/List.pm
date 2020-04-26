package Erlang::List;
use Mouse;

has elements => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has tail => (
    is => 'rw',
    default => undef,
);

sub length {
    return scalar @{$_[0]->elements()};
}

sub at {
    return $_[0]->elements()->[$_[1]];
}

1;
