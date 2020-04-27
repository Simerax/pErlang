use Test::More tests => 6;
use pErlang::Type;

require_ok('pErlang::Atom');


{
    my $atom = pErlang::Atom->new(name => 'ok', subtype => pErlang::Type::ATOM_EXT);
    isa_ok($atom, 'pErlang::Atom');
    ok($atom->name() eq 'ok', "Atom Name being set by constructor");
    ok("$atom" eq 'ok', "Atom Stringify");
    ok($atom->subtype() == pErlang::Type::ATOM_EXT, "Atom Subtype is set by constructor");
    
    my $encoded = $atom->encode();
    my $expected = chr(pErlang::Type::ATOM_EXT).pack("n", 2).$atom->name();
    ok($encoded eq $expected, "Atom can be encoded");
}

# TODO: Add tests for UTF8 atoms
