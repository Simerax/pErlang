use Test::More tests => 7;
use pErlang::Type;

require_ok('pErlang::Atom');


{
    my $atom = pErlang::Atom->new(name => 'ok', subtype => pErlang::Type::ATOM_EXT);
    isa_ok($atom, 'pErlang::Atom');
    ok($atom->name() eq 'ok', "Atom Name being set by constructor");
    ok("$atom" eq 'ok', "Atom Stringify");
    ok($atom->subtype() eq pErlang::Type::ATOM_EXT, "Atom Subtype is set by constructor");
    
    my $encoded = $atom->encode();
    my $expected = "\x64\x00\x02\x6F\x6B";
    ok($encoded eq $expected, "Atom can be encoded");
}

{
    use utf8;
    my $str = 'также';
    utf8::encode($str);
    my $atom = pErlang::Atom->new(name => $str, subtype => pErlang::Type::SMALL_ATOM_UTF8_EXT);
    
    my $encoded = $atom->encode();
    my $expected = "\x77\x0A\xD1\x82\xD0\xB0\xD0\xBA\xD0\xB6\xD0\xB5";
    ok($encoded eq $expected, "Atom can be encoded");
    no utf8;
}
