use Test::More tests => 49;
use Erlang::Type;

use utf8;

require_ok('Erlang::Decode');

# Sysread can't handle in memory streams so we use perl's 'read' for the tests
# https://github.com/Perl/perl5/issues/10125
$Erlang::Decode::USE_PERL_READ_FUNCTION = 1; 


{
    my $TEST_NAME = 'Decode uncompressed ATOM_EXT message';

    # Erlang External Term Format Message uncompressed ATOM_EXT with value "shutdown"
    my $message = "\x83\x64\x00\x08\x73\x68\x75\x74\x64\x6F\x77\x6E";

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Atom');
    ok($decoded->name() eq 'shutdown', $TEST_NAME);
}
{
    my $TEST_NAME = 'Decode uncompressed SMALL_ATOM_UTF8_EXT message';

    # Small UTF8 Atom with value 'мои'
    my $message = "\x83\x77\x06\xD0\xBC\xD0\xBE\xD0\xB8";

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Atom');
    print "--> ".$decoded->subtype()."\n";
    ok($decoded->subtype() == Erlang::Type::SMALL_ATOM_UTF8_EXT);

    my $expected = 'мои';
    utf8::encode($expected);

    ok($expected eq $decoded->name(), $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed binary message';
    my $message = "\x83\x6D\x00\x00\x00\x05\x68\x65\x6C\x6C\x6F"; # Binary String 'hello'

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Binary');
    ok($decoded->data() eq 'hello', $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed 8-Bit Integer message';
    my $message = "\x83\x61\x95";

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Integer');
    ok($decoded->subtype() == Erlang::Type::SMALL_INTEGER_EXT);
    ok($decoded->value() == 149, $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed positive 32-Bit Integer message';
    my $message = "\x83\x62\x02\x84\x76\xFC"; # Integer 42235644

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Integer');
    ok($decoded->subtype() == Erlang::Type::INTEGER_EXT);
    ok($decoded->value() == 42235644, $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed negative 32-Bit Integer message';
    my $message = "\x83\x62\xFF\xFB\x84\x29"; # Integer -293847

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Integer');
    ok($decoded->subtype() == Erlang::Type::INTEGER_EXT);
    ok($decoded->value() == -293847, $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed tuple with atom and small integer';
    my $message = "\x83\x68\x02\x64\x0\x02\x6F\x6B\x61\x19"; # tuple {ok, 25}

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Tuple');
    ok($decoded->subtype() == Erlang::Type::SMALL_TUPLE_EXT);
    ok($decoded->arity() == 2);
    ok($decoded->at(0)->isa('Erlang::Atom'));
    ok($decoded->at(1)->isa('Erlang::Integer'), $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed Large tuple';
    # yeah i guess this is overkill
    my $message = "\x83\x69\x00\x00\x01\x18\x62\x00\x00\x01\x18\x62\x00\x00\x01\x17\x62\x00\x00\x01\x16\x62\x00\x00\x01\x15\x62\x00\x00\x01\x14\x62\x00\x00\x01\x13\x62\x00\x00\x01\x12\x62\x00\x00\x01\x11\x62\x00\x00\x01\x10\x62\x00\x00\x01\x0f\x62\x00\x00\x01\x0e\x62\x00\x00\x01\x0d\x62\x00\x00\x01\x0c\x62\x00\x00\x01\x0b\x62\x00\x00\x01\x0a\x62\x00\x00\x01\x09\x62\x00\x00\x01\x08\x62\x00\x00\x01\x07\x62\x00\x00\x01\x06\x62\x00\x00\x01\x05\x62\x00\x00\x01\x04\x62\x00\x00\x01\x03\x62\x00\x00\x01\x02\x62\x00\x00\x01\x01\x62\x00\x00\x01\x00\x61\xff\x61\xfe\x61\xfd\x61\xfc\x61\xfb\x61\xfa\x61\xf9\x61\xf8\x61\xf7\x61\xf6\x61\xf5\x61\xf4\x61\xf3\x61\xf2\x61\xf1\x61\xf0\x61\xef\x61\xee\x61\xed\x61\xec\x61\xeb\x61\xea\x61\xe9\x61\xe8\x61\xe7\x61\xe6\x61\xe5\x61\xe4\x61\xe3\x61\xe2\x61\xe1\x61\xe0\x61\xdf\x61\xde\x61\xdd\x61\xdc\x61\xdb\x61\xda\x61\xd9\x61\xd8\x61\xd7\x61\xd6\x61\xd5\x61\xd4\x61\xd3\x61\xd2\x61\xd1\x61\xd0\x61\xcf\x61\xce\x61\xcd\x61\xcc\x61\xcb\x61\xca\x61\xc9\x61\xc8\x61\xc7\x61\xc6\x61\xc5\x61\xc4\x61\xc3\x61\xc2\x61\xc1\x61\xc0\x61\xbf\x61\xbe\x61\xbd\x61\xbc\x61\xbb\x61\xba\x61\xb9\x61\xb8\x61\xb7\x61\xb6\x61\xb5\x61\xb4\x61\xb3\x61\xb2\x61\xb1\x61\xb0\x61\xaf\x61\xae\x61\xad\x61\xac\x61\xab\x61\xaa\x61\xa9\x61\xa8\x61\xa7\x61\xa6\x61\xa5\x61\xa4\x61\xa3\x61\xa2\x61\xa1\x61\xa0\x61\x9f\x61\x9e\x61\x9d\x61\x9c\x61\x9b\x61\x9a\x61\x99\x61\x98\x61\x97\x61\x96\x61\x95\x61\x94\x61\x93\x61\x92\x61\x91\x61\x90\x61\x8f\x61\x8e\x61\x8d\x61\x8c\x61\x8b\x61\x8a\x61\x89\x61\x88\x61\x87\x61\x86\x61\x85\x61\x84\x61\x83\x61\x82\x61\x81\x61\x80\x61\x7f\x61\x7e\x61\x7d\x61\x7c\x61\x7b\x61\x7a\x61\x79\x61\x78\x61\x77\x61\x76\x61\x75\x61\x74\x61\x73\x61\x72\x61\x71\x61\x70\x61\x6f\x61\x6e\x61\x6d\x61\x6c\x61\x6b\x61\x6a\x61\x69\x61\x68\x61\x67\x61\x66\x61\x65\x61\x64\x61\x63\x61\x62\x61\x61\x61\x60\x61\x5f\x61\x5e\x61\x5d\x61\x5c\x61\x5b\x61\x5a\x61\x59\x61\x58\x61\x57\x61\x56\x61\x55\x61\x54\x61\x53\x61\x52\x61\x51\x61\x50\x61\x4f\x61\x4e\x61\x4d\x61\x4c\x61\x4b\x61\x4a\x61\x49\x61\x48\x61\x47\x61\x46\x61\x45\x61\x44\x61\x43\x61\x42\x61\x41\x61\x40\x61\x3f\x61\x3e\x61\x3d\x61\x3c\x61\x3b\x61\x3a\x61\x39\x61\x38\x61\x37\x61\x36\x61\x35\x61\x34\x61\x33\x61\x32\x61\x31\x61\x30\x61\x2f\x61\x2e\x61\x2d\x61\x2c\x61\x2b\x61\x2a\x61\x29\x61\x28\x61\x27\x61\x26\x61\x25\x61\x24\x61\x23\x61\x22\x61\x21\x61\x20\x61\x1f\x61\x1e\x61\x1d\x61\x1c\x61\x1b\x61\x1a\x61\x19\x61\x18\x61\x17\x61\x16\x61\x15\x61\x14\x61\x13\x61\x12\x61\x11\x61\x10\x61\x0f\x61\x0e\x61\x0d\x61\x0c\x61\x0b\x61\x0a\x61\x09\x61\x08\x61\x07\x61\x06\x61\x05\x61\x04\x61\x03\x61\x02\x61\x01";

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Tuple');
    ok($decoded->subtype() == Erlang::Type::LARGE_TUPLE_EXT);
    ok($decoded->arity() == 280, $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed float message';
    my $message = "\x83\x46\x40\x02\x66\x66\x66\x66\x66\x66"; # float 2.3 NEW FLOAT TYPE 70!

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Float');
    ok($decoded->subtype() == Erlang::Type::NEW_FLOAT_EXT);
    ok($decoded->value() == 2.3, $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed list message';
    # list with two binaries
    # ["hello", "bye"]
    my $message = "\x83\x6C\x00\x00\x00\x02\x6D\x00\x00\x00\x05\x68\x65\x6C\x6C\x6F\x6D\x00\x00\x00\x03\x62\x79\x65\x6A";

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::List');
    ok($decoded->length() == 2);
    ok($decoded->at(0) eq "hello");
    ok($decoded->at(1) eq "bye");
    ok($decoded->tail()->isa('Erlang::Nil'), $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed nil message';
    my $message = "\x83\x6A"; # nil []

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $decoded) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($decoded, 'Erlang::Nil', $TEST_NAME);
}

{
    my $TEST_NAME = 'Decode uncompressed map message';
    # map with two keys 
    # %{a => 2, b => "hello"}
    my $message = "\x83\x74\x00\x00\x00\x02\x64\x00\x01\x61\x61\x02\x64\x00\x01\x62\x6D\x00\x00\x00\x05\x68\x65\x6C\x6C\x6F";

    my $stream;
    open($stream, '<', \$message);
    my ($ok, $map) = Erlang::Decode::decode($stream);
    ok($ok == 1);
    isa_ok($map, 'Erlang::Map');

    my $a = $map->get(Erlang::Atom->new(name => 'a'));
    isa_ok($a, 'Erlang::Integer');
    my $b = $map->get(Erlang::Atom->new(name => 'b'));
    isa_ok($b, 'Erlang::Binary');

    
}

