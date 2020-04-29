package pErlang::Encode;
use warnings;
use strict;

use pErlang::Encoder::Strict;
use pErlang::Type qw(:constants);


sub encode {
    my ($thing, $encoder) = @_;
    $encoder //= pErlang::Encoder::Strict->new();
    $encoder->visit($thing);
    return VERSION_PREFIX . $encoder->result();
}

1;
