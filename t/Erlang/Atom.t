use Test::More tests => 6;
use Erlang::Type;

require_ok('Erlang::Atom');


{
    my $atom = Erlang::Atom->new(name => 'ok', subtype => Erlang::Type::ATOM_EXT);
    isa_ok($atom, 'Erlang::Atom');
    ok($atom->name() eq 'ok', "Atom Name being set by constructor");
    ok("$atom" eq 'ok', "Atom Stringify");
    ok($atom->subtype() == Erlang::Type::ATOM_EXT, "Atom Subtype is set by constructor");
    
    my $encoded = $atom->encode();
    my $expected = chr(Erlang::Type::ATOM_EXT).pack("n", 2).$atom->name();
    ok($encoded eq $expected, "Atom can be encoded");
}

# TODO: Add tests for UTF8 atoms
