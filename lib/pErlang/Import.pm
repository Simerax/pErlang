package pErlang::Import;

use pErlang::Type qw(:constants);
use pErlang::Atom;
use pErlang::Float;
use pErlang::Integer;
use pErlang::Binary;
use pErlang::String;
use pErlang::Map;
use pErlang::List;
use pErlang::Tuple;
use pErlang::Encode;
use pErlang::Decode;

use Exporter qw(import);

our @EXPORT_OK = qw(
    AtomUTF8
    Atom
    Float
    Integer
    Integer8bit
    Binary
    Map
    List
    Tuple
    String
    encode
    decode
);

our %EXPORT_TAGS = (
    all => [@EXPORT_OK],
    types => qw(
        AtomUTF8
        Atom
        Float
        Integer
        Integer8bit
        Binary
        Map
        List
        Tuple
        String
    ),
);

sub encode {
    return pErlang::Encode::encode(@_);
}

sub decode {
    return pErlang::Decode::decode(@_);
}

sub AtomUTF8 {
    my ($name) = @_;
    return pErlang::Atom->new(name => $name, subtype => ATOM_UTF8_EXT);
}

sub Atom {
    my ($name) = @_;
    return pErlang::Atom->new(name => $name, subtype => ATOM_EXT);
}

sub Float {
    my ($value) = @_;
    return pErlang::Float->new(value => $value, subtype => NEW_FLOAT_EXT);
}

sub Integer8bit {
    my ($num) = @_;
    return pErlang::Integer->new(value => $num, subtype => SMALL_INTEGER_EXT);
}

sub Integer {
    my ($num) = @_;
    print "----------> $num\n";
    return pErlang::Integer->new(value => $num, subtype => INTEGER_EXT);
}

sub Binary {
    my ($data) = @_;
    return pErlang::Binary->new(data => $data);
}

sub String {
    my ($data) = @_;
    return pErlang::String->new(data => $data);
}

sub Map {
    return pErlang::Map->new();
}

sub List {
    return pErlang::List->new();
}

sub Tuple {
    return pErlang::Tuple->new();
}

1;
