package Erlang::Type;
use Exporter qw(import);

our @EXPORT_OK = qw(
    is_binary
    is_string
    is_small_list
    is_list
    is_map
    is_small_tuple
    is_large_tuple
    is_tuple
    is_8bit_integer
    is_32bit_integer
    is_float
    is_new_float
    is_old_float
    is_atom
    is_atom_utf8
    is_atom_utf8_small
    is_atom_ext
    is_nil
);
our %EXPORT_TAGS = (all => [@EXPORT_OK]);



use constant {
    NIL_EXT => 106,

    ATOM_EXT => 100,
    SMALL_ATOM_UTF8_EXT => 119,
    ATOM_UTF8_EXT => 118,

    SMALL_INTEGER_EXT => 97,
    INTEGER_EXT => 98,

    FLOAT_EXT => 99, # old Float - used in external format minor version 0
    NEW_FLOAT_EXT => 70,

    SMALL_TUPLE_EXT => 104,
    LARGE_TUPLE_EXT => 105,

    MAP_EXT => 116,

    STRING_EXT => 107, # actually charlists with values 0-255 sent as bytearray
    LIST_EXT => 108,
    BINARY_EXT => 109,
};

sub is_nil {
    return ord($_[0]) == NIL_EXT;
}

sub is_binary {
    return ord($_[0]) == BINARY_EXT;
}

# FIXME: well...elixir uses binaries as strings
# but maybe it's misleading for erlang?
sub is_string {
    return is_binary(@_);
}

sub is_small_list {
    return ord($_[0]) == STRING_EXT;
}

sub is_list {
    return ord($_[0]) == LIST_EXT;
}


sub is_map {
    return ord($_[0]) == MAP_EXT;
}

sub is_small_tuple {
    return ord($_[0]) == SMALL_TUPLE_EXT;
}

sub is_large_tuple {
    return ord($_[0]) == LARGE_TUPLE_EXT;
}

sub is_tuple {
    return is_small_tuple($_[0]) || is_large_tuple($_[0]);
}

sub is_8bit_integer {
    return ord($_[0]) == SMALL_INTEGER_EXT;
}

sub is_32bit_integer {
    return ord($_[0]) == INTEGER_EXT;
}

sub is_float {
    return is_new_float($_[0]) || is_old_float($_[0]);
}

sub is_new_float {
    return ord($_[0]) == NEW_FLOAT_EXT;
}

sub is_old_float {
    return ord($_[0]) == FLOAT_EXT;
}

sub is_atom {
    return is_atom_ext($_[0]) || is_atom_utf8($_[0]) || is_atom_utf8_small($_[0]);
}
sub is_atom_ext {
    return ord($_[0]) == ATOM_EXT;
}
sub is_atom_utf8 {
    return ord($_[0]) == ATOM_UTF8_EXT;
}
sub is_atom_utf8_small {
    return ord($_[0]) == SMALL_ATOM_UTF8_EXT;
}
