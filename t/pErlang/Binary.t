use Test::More tests => 8;

require_ok('pErlang::Binary');

{
    my $binary = pErlang::Binary->new(data => 'hello');
    isa_ok($binary, 'pErlang::Binary');
    ok($binary eq 'hello');
    ok($binary ne 'bye');
    ok($binary != 'hello'); # different types
    ok($binary != pErlang::Binary->new(data => 'bye'));
    ok($binary == pErlang::Binary->new(data => 'hello'));
    ok("$binary" eq "hello");
}
