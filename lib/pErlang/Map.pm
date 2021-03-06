package pErlang::Map;
use Mouse;

extends 'pErlang::Datastructure';

use pErlang::Pair;

# We can't just use a Hash because this would stringify the keys
# For example if a key was an atom it would be stringified and when encoded again we would not
# know if it should be a string/binary or an atom
has pairs => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

sub contains {
    my ($self, $key) = @_;
    my $pairs = $self->pairs();
    my $obj_type = blessed($key);
    if(!defined $obj_type || !$key->isa('pErlang::Datastructure')) {
        warn __PACKAGE__." lookup should always be done with an pErlang Datastructure!";
        return -1;
    }
    for(0..scalar @{$pairs}) {
        my $pair = $pairs->[$_];
        next unless defined $pair;

        if($pair->a()->isa($obj_type) && $pair->a() == $key) {
            return $_;
        }

    }
    return -1;
}

sub num_of_pairs {
    my($self) = @_;
    return scalar @{$self->pairs()};
}

sub put {
    my ($self, $key, $value) = @_;

    # TODO: This is really not failsafe and should be extended it the future
    $key = pErlang::Binary->new(data => $key) if(ref($key) eq "");

    my $index = $self->contains($key);
    my $pairs_ref = $self->pairs();
    if($index == -1) {
        push @$pairs_ref, pErlang::Pair->new(
            a => $key,
            b => $value,
        ); 
    } else {
        $self->pairs()->[$index]->b($value);
    }
}

sub get {
    my ($self, $key) = @_;

    # TODO: This is really not failsafe and should be extended it the future
    $key = pErlang::Binary->new(data => $key) if(ref($key) eq "");

    my $index = $self->contains($key);
    if ($index == -1) {
        return undef;
    } else {
        return $self->pairs()->[$index]->b();
    }
}

1;
