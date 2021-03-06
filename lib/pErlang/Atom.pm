package pErlang::Atom;
use Mouse;
use pErlang::Type;

extends 'pErlang::Datastructure';

use overload
    'eq' => \&equals,
    '""' => \&to_string,
    '==' => \&equals;

has name => (
    is => 'rw',
    isa => 'Str',
    required => 1,
);

has subtype => (
    is => 'rw',
    isa => 'Str',
    default => pErlang::Type::ATOM_UTF8_EXT,
    trigger => sub {
        my ($self, $type) = @_;
        if($type ne pErlang::Type::ATOM_EXT &&
            $type ne pErlang::Type::ATOM_UTF8_EXT &&
            $type ne pErlang::Type::SMALL_ATOM_UTF8_EXT)
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);


sub equals {
    my ($self, $other) = @_;
    if(UNIVERSAL::isa($other, 'pErlang::Atom')) {
        return $self->name() eq $other->name();
    } else {
        return $self->name() eq $other;
    }
}

sub encode {
    my ($self) = @_;
    my $len = length($self->name());

    my $encoded;
    if($self->subtype() eq pErlang::Type::ATOM_EXT || $self->subtype() eq pErlang::Type::ATOM_UTF8_EXT) {
        $encoded = $self->subtype() . pack('n', $len);
    }
    if($self->subtype() eq pErlang::Type::SMALL_ATOM_UTF8_EXT) {
        if($len <= 255) {
            $encoded = $self->subtype() . pack('C', $len);
        } else {
            $encoded = pErlang::Type::ATOM_UTF8_EXT . pack('n', $len);
        }
    }

    return $encoded . $self->name();
}

sub to_string {
    return $_[0]->name();
}

1;
