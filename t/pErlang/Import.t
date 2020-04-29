use Test::More tests => 10;

use pErlang::Import qw(:all);

isa_ok(Atom("hi"), "pErlang::Atom");
isa_ok(AtomUTF8("hello"), "pErlang::Atom");
isa_ok(Float(2.3), "pErlang::Float");
isa_ok(Binary("hi there"), "pErlang::Binary");
isa_ok(String("this is a string"), "pErlang::String");
isa_ok(Map(), "pErlang::Map");
isa_ok(List(), "pErlang::List");
isa_ok(Tuple(), "pErlang::Tuple");
isa_ok(Integer(3), "pErlang::Integer");
isa_ok(Integer8bit(2), "pErlang::Integer");


