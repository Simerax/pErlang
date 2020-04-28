package pErlang::Role::Encoder;
use Mouse::Role;
use Scalar::Util qw(blessed);

requires qw(result reset);


sub visit {
    my ($self, $thing) = @_;
    # yeah I know maybe a little much magic
    my $type = blessed($thing);
    $type =~ s/::/_/g;
    my $fun = 'visit_'.$type;
    $self->$fun($thing);
}

1;
