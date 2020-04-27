use Test::More tests => 8;

require_ok('Erlang::String');

{
    my $string = Erlang::String->new(data => 'hello');
    isa_ok($string, 'Erlang::String');
    ok($string eq 'hello');
    ok($string ne 'bye');
    ok($string != 'hello'); # different types
    ok($string != Erlang::String->new(data => 'bye'));
    ok($string == Erlang::String->new(data => 'hello'));
    ok("$string" eq "hello");
}
