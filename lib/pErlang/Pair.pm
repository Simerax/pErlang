package pErlang::Pair;
use Mouse;

# Not really a erlang datatype but a helper for pErlang::Map

has a => (
    is => 'rw',
    isa => 'pErlang::Datastructure',
);
has b => (
    is => 'rw',
    isa => 'pErlang::Datastructure',
);

1;
