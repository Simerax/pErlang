use Test::More tests => 2;
require_ok('pErlang::Float');



{
    my $TEST_NAME = "Float Addition";

    my $float = pErlang::Float->new(value => 3.4);
    ok($float + 2 == 5.4, $TEST_NAME);
}
