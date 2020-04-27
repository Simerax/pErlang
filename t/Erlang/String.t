use Test::More tests => 8;

require_ok('pErlang::String');

{
    my $string = pErlang::String->new(data => 'hello');
    isa_ok($string, 'pErlang::String');
    ok($string eq 'hello');
    ok($string ne 'bye');
    ok($string != 'hello'); # different types
    ok($string != pErlang::String->new(data => 'bye'));
    ok($string == pErlang::String->new(data => 'hello'));
    ok("$string" eq "hello");
}
