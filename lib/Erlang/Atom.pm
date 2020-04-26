package Erlang::Atom;
use Mouse;
use Erlang::Type;

extends 'Erlang::Datastructure';

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
    isa => 'Num',
    default => Erlang::Type::ATOM_UTF8_EXT,
    trigger => sub {
        my ($self, $type) = @_;
        if($type != Erlang::Type::ATOM_EXT &&
            $type != Erlang::Type::ATOM_UTF8_EXT &&
            $type != Erlang::Type::SMALL_ATOM_UTF8_EXT)
        {
            confess("Invalid subtype '$type' for ".__PACKAGE__);
        }
    },
);

has is_utf8 => (
    is => 'rw',
    isa => 'Bool',
    default => 0,
);

sub equals {
    my ($self, $other) = @_;
    if(UNIVERSAL::isa($other, 'Erlang::Atom')) {
        return $self->name() eq $other->name();
    } else {
        return $self->name() eq $other;
    }
}

sub encode {
    my ($self) = @_;
    my $len = length($self->name());
    my $type;
    if($self->is_utf8()) {
        $type = chr(Erlang::Type::ATOM_UTF8_EXT);
    } else {
        $type = chr(Erlang::Type::ATOM_EXT);
    }

    return $type.pack("n",$len).$self->name();
}

sub to_string {
    return $_[0]->name();
}

1;
