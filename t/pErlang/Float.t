use Test::More tests => 5;
require_ok('pErlang::Float');



{
    my $TEST_NAME = "Float Addition";

    my $float = pErlang::Float->new(value => 3.4);
    ok($float + 2 == 5.4, $TEST_NAME);
}

{
    my $TEST_NAME = "Float Subtraction";

    my $float = pErlang::Float->new(value => 5.4);
    ok(5.4 - $float == 0, $TEST_NAME);
    ok($float - 10.4 == -5, $TEST_NAME);
}

{
    my $TEST_NAME = "Float to string";

    my $float = pErlang::Float->new(value => 5.4);
    ok("$float" eq "5.4", $TEST_NAME);
}
