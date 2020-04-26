package Erlang::Pair;
use Mouse;

# Not really a erlang datatype but a helper for Erlang::Map

has a => (
    is => 'rw',
    isa => 'Erlang::Datastructure',
);
has b => (
    is => 'rw',
    isa => 'Erlang::Datastructure',
);

1;
