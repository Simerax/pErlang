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
    isa => 'Num',
    default => pErlang::Type::NEW_FLOAT_EXT,
    trigger => sub {
        my ($self, $type) = @_;
        if($type != pErlang::Type::NEW_FLOAT_EXT &&
            $type != pErlang::Type::FLOAT_EXT)
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

1;
