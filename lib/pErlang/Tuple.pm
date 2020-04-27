package pErlang::Tuple;
use Mouse;

extends 'pErlang::Datastructure';

has arity => (
    is => 'rw',
    isa => 'Int',
);

has elements => (
    is => 'rw',
    isa => 'ArrayRef',
);

has subtype => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    trigger => sub {
        my ($self, $type) = @_;
        if($type ne pErlang::Type::SMALL_TUPLE_EXT &&
            $type ne pErlang::Type::LARGE_TUPLE_EXT )
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

sub at {
    return $_[0]->elements()->[$_[1]];
}

1;
