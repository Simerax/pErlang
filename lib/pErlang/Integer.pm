package pErlang::Integer;
use Mouse;

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
        if($type ne pErlang::Type::SMALL_INTEGER_EXT &&
            $type ne pErlang::Type::INTEGER_EXT )
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

1;
