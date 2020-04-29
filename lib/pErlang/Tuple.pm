package pErlang::Tuple;
use Mouse;
use pErlang::Type qw(:constants);

extends 'pErlang::Datastructure';


has elements => (
    is => 'rw',
    isa => 'ArrayRef',
);

has subtype => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    default => SMALL_TUPLE_EXT,
    trigger => sub {
        my ($self, $type) = @_;
        if($type ne pErlang::Type::SMALL_TUPLE_EXT &&
            $type ne pErlang::Type::LARGE_TUPLE_EXT )
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

sub length {return arity(@_)};
sub arity {
    return scalar @{$_[0]->elements()};
}

sub at {
    return $_[0]->elements()->[$_[1]];
}

1;
