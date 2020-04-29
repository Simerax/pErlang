package pErlang::Float;
use Mouse;
use pErlang::Type qw(:constants);

extends 'pErlang::Datastructure';

has value => (
    is => 'rw',
    isa => 'Num',
    default => 0.0,
);

has subtype => (
    is => 'rw',
    isa => 'Str',
    default => NEW_FLOAT_EXT,
    trigger => sub {
        my ($self, $type) = @_;
        if($type ne NEW_FLOAT_EXT &&
            $type ne FLOAT_EXT)
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

1;
