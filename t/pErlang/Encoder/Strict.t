use Test::More tests => 12;

require_ok('pErlang::Encoder::Strict');

use pErlang::Type qw(:constants);
use pErlang::List;
use pErlang::Integer;
use pErlang::Atom;
use pErlang::Nil;
use pErlang::Binary;
use pErlang::Float;
use pErlang::Tuple;
use pErlang::String;
use pErlang::Map;


{
    my $TEST_NAME = 'Encode a small (8bit) integer';
    my $int = pErlang::Integer->new(value => 23, subtype => SMALL_INTEGER_EXT);
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($int);
    my $result = $encoder->result();
    ok($result eq "\x61\x17", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a large (32bit) integer';
    my $int = pErlang::Integer->new(value => 32420, subtype => INTEGER_EXT);
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($int);
    my $result = $encoder->result();
    ok($result eq "\x62\x00\x00\x7E\xA4", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode an ATOM_EXT';
    my $atom = pErlang::Atom->new(name => 'hello', subtype => ATOM_EXT);
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($atom);
    my $result = $encoder->result();
    ok($result eq "\x64\x00\x05\x68\x65\x6C\x6C\x6F", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a SMALL_ATOM_UTF8_EXT';
    use utf8;
    my $str = 'хорошо';
    utf8::encode($str);
    my $atom = pErlang::Atom->new(name => $str, subtype => SMALL_ATOM_UTF8_EXT);
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($atom);
    my $result = $encoder->result();
    ok($result eq "\x77\x0C\xD1\x85\xD0\xBE\xD1\x80\xD0\xBE\xD1\x88\xD0\xBE", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a NIL';

    my $nil = pErlang::Nil->new();
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($nil);
    my $result = $encoder->result();
    ok($result eq "\x6A", $TEST_NAME);
}
{
    my $TEST_NAME = 'Encode a Binary';

    my $binary = pErlang::Binary->new(data => 'test');
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($binary);
    my $result = $encoder->result();
    ok($result eq "\x6D\x00\x00\x00\x04\x74\x65\x73\x74", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a List';

    my $list = pErlang::List->new();
    $list->push(pErlang::Binary->new(data => 'abc'));

    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($list);
    my $result = $encoder->result();
    ok($result eq "\x6C\x00\x00\x00\x01\x6D\x00\x00\x00\x03\x61\x62\x63\x6A", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a Float';

    my $float = pErlang::Float->new(value => 3.5);
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($float);
    my $result = $encoder->result();
    ok($result eq "\x46\x40\x0C\x00\x00\x00\x00\x00\x00", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a Tuple';

    my $tuple = pErlang::Tuple->new(
        elements => [
            pErlang::Atom->new(name => 'ok', subtype => ATOM_EXT),
            pErlang::Float->new(value => 3.5),
            pErlang::Float->new(value => 2344.0)
        ],
    );

    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($tuple);
    my $result = $encoder->result();
    ok($result eq "\x68\x03\x64\x00\x02\x6F\x6B\x46\x40\x0C\x00\x00\x00\x00\x00\x00\x46\x40\xA2\x50\x00\x00\x00\x00\x00", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a String/Charlist';

    my $string = pErlang::String->new(data => "oijl");
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($string);
    my $result = $encoder->result();
    ok($result eq "\x6B\x00\x04\x6F\x69\x6A\x6C", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a Map';

    my $map = pErlang::Map->new();
    $map->put("a", pErlang::Float->new(value => 2.3));

    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($map);
    my $result = $encoder->result();
    ok($result eq "\x74\x00\x00\x00\x01\x6D\x00\x00\x00\x01\x61\x46\x40\x02\x66\x66\x66\x66\x66\x66", $TEST_NAME);
}
