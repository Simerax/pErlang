package pErlang::Float;
use Mouse;
use pErlang::Type qw(:constants);
use Scalar::Util qw(looks_like_number);

extends 'pErlang::Datastructure';

use overload
    '+' => \&add,
    '==' => \&equals,

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

sub add {
    my ($self, $other, $swap) = @_;

    if($swap) {
        my $tmp = $self;
        $self = $other;
        $other = $tmp;
    }

    return pErlang::Float->new(value => $self->value() + $other, subtype => $self->subtype());
}

sub equals {
    my ($self, $other) = @_;

    if(UNIVERSAL::isa($other, 'pErlang::Float') && $other->value() == $self->value()) {
        return 1;
    } elsif(looks_like_number($other) && $self->value() == $other) {
        return 1;
    } else {
        return 0;
    }
}


1;
