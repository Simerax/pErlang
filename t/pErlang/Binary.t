use Test::More tests => 9;

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

    my $encoded = $binary->encode();
    my $expected = "\x6D\x00\x00\x00\x05\x68\x65\x6C\x6C\x6F";
    ok($encoded eq $expected, "Binary can be encoded");
}
