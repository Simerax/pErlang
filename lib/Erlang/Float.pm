package Erlang::Float;
use Mouse;

extends 'Erlang::Datastructure';

has value => (
    is => 'rw',
    isa => 'Num',
    default => 0.0,
);

has subtype => (
    is => 'rw',
    isa => 'Num',
    default => Erlang::Type::NEW_FLOAT_EXT,
    trigger => sub {
        my ($self, $type) = @_;
        if($type != Erlang::Type::NEW_FLOAT_EXT &&
            $type != Erlang::Type::FLOAT_EXT)
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

1;
