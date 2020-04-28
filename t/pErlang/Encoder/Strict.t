use Test::More tests => 3;

require_ok('pErlang::Encoder::Strict');

use pErlang::Type qw(:constants);


{
    my $TEST_NAME = 'Encode a small (8bit) integer';
    use pErlang::Integer;
    my $int = pErlang::Integer->new(value => 23, subtype => SMALL_INTEGER_EXT);
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($int);
    my $result = $encoder->result();
    ok($result eq "\x61\x17", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a large (32bit) integer';
    use pErlang::Integer;
    my $int = pErlang::Integer->new(value => 32420, subtype => INTEGER_EXT);
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($int);
    my $result = $encoder->result();
    ok($result eq "\x62\x00\x00\x7E\xA4", $TEST_NAME);
}
