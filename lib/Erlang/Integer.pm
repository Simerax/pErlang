package Erlang::Integer;
use Mouse;

has value => (
    is => 'rw',
    isa => 'Num',
    required => 1,
);

has subtype => (
    is => 'rw',
    isa => 'Num',
    required => 1,
    trigger => sub {
        my ($self, $type) = @_;
        if($type != Erlang::Type::SMALL_INTEGER_EXT &&
            $type != Erlang::Type::INTEGER_EXT )
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

1;
