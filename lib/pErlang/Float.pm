package pErlang::Float;
use Mouse;

extends 'pErlang::Datastructure';

has value => (
    is => 'rw',
    isa => 'Num',
    default => 0.0,
);

has subtype => (
    is => 'rw',
    isa => 'Str',
    default => pErlang::Type::NEW_FLOAT_EXT,
    trigger => sub {
        my ($self, $type) = @_;
        if($type ne pErlang::Type::NEW_FLOAT_EXT &&
            $type ne pErlang::Type::FLOAT_EXT)
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

1;
