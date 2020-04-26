use Test::More tests => 25;
use Erlang::Type;

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
    $Erlang::Decode::USE_PERL_READ_FUNCTION = 1; # Sysread can't handle in memory streams
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
    my $message = "\x83\x68\x02\x64\x0\x02\x6F\x6B\x61\x19"; # Integer -293847

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
