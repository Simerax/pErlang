package Erlang::Tuple;
use Mouse;

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
    isa => 'Num',
    required => 1,
    trigger => sub {
        my ($self, $type) = @_;
        if($type != Erlang::Type::SMALL_TUPLE_EXT &&
            $type != Erlang::Type::LARGE_TUPLE_EXT )
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

sub at {
    return $_[0]->elements()->[$_[1]];
}

1;
