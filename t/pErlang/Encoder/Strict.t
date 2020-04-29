use Test::More tests => 7;

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

{
    my $TEST_NAME = 'Encode an ATOM_EXT';
    use pErlang::Atom;
    my $atom = pErlang::Atom->new(name => 'hello', subtype => ATOM_EXT);
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($atom);
    my $result = $encoder->result();
    ok($result eq "\x64\x00\x05\x68\x65\x6C\x6C\x6F", $TEST_NAME);
}

{
    my $TEST_NAME = 'Encode a SMALL_ATOM_UTF8_EXT';
    use pErlang::Atom;
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
    use pErlang::Nil;

    my $nil = pErlang::Nil->new();
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($nil);
    my $result = $encoder->result();
    ok($result eq "\x6A", $TEST_NAME);
}
{
    my $TEST_NAME = 'Encode a Binary';
    use pErlang::Binary;

    my $binary = pErlang::Binary->new(data => 'test');
    my $encoder = pErlang::Encoder::Strict->new();
    $encoder->visit($binary);
    my $result = $encoder->result();
    ok($result eq "\x6D\x00\x00\x00\x04\x74\x65\x73\x74", $TEST_NAME);
}
