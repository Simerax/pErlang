package pErlang::Integer;
use Mouse;
use pErlang::Type qw(:constants);

extends 'pErlang::Datastructure';

has value => (
    is => 'rw',
    isa => 'Num',
    required => 1,
);

has subtype => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    trigger => sub {
        my ($self, $type) = @_;
        if($type ne SMALL_INTEGER_EXT &&
            $type ne INTEGER_EXT )
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

1;
