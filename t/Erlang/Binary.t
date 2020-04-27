use Test::More tests => 8;

require_ok('Erlang::Binary');

{
    my $binary = Erlang::Binary->new(data => 'hello');
    isa_ok($binary, 'Erlang::Binary');
    ok($binary eq 'hello');
    ok($binary ne 'bye');
    ok($binary != 'hello'); # different types
    ok($binary != Erlang::Binary->new(data => 'bye'));
    ok($binary == Erlang::Binary->new(data => 'hello'));
    ok("$binary" eq "hello");
}
