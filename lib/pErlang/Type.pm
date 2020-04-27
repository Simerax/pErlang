package pErlang::Type;
use Exporter qw(import);

our @EXPORT_OK = qw(
    is_binary
    is_string
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
    NIL_EXT => chr(106),

    ATOM_EXT => chr(100),
    SMALL_ATOM_UTF8_EXT => chr(119),
    ATOM_UTF8_EXT => chr(118),

    SMALL_INTEGER_EXT => chr(97),
    INTEGER_EXT => chr(98),

    FLOAT_EXT => chr(99), # old Float - used in external format minor version 0
    NEW_FLOAT_EXT => chr(70),

    SMALL_TUPLE_EXT => chr(104),
    LARGE_TUPLE_EXT => chr(105),

    MAP_EXT => chr(116),

    STRING_EXT => chr(107), # actually charlists with values 0-255 sent as bytearray
    LIST_EXT => chr(108),
    BINARY_EXT => chr(109),
};

sub is_nil {
    return $_[0] eq NIL_EXT;
}

sub is_binary {
    return $_[0] eq BINARY_EXT;
}

sub is_string {
    return $_[0] eq STRING_EXT;
}

sub is_list {
    return $_[0] eq LIST_EXT;
}


sub is_map {
    return $_[0] eq MAP_EXT;
}

sub is_small_tuple {
    return $_[0] eq SMALL_TUPLE_EXT;
}

sub is_large_tuple {
    return $_[0] eq LARGE_TUPLE_EXT;
}

sub is_tuple {
    return is_small_tuple($_[0]) || is_large_tuple($_[0]);
}

sub is_8bit_integer {
    return $_[0] eq SMALL_INTEGER_EXT;
}

sub is_32bit_integer {
    return $_[0] eq INTEGER_EXT;
}

sub is_float {
    return is_new_float($_[0]) || is_old_float($_[0]);
}

sub is_new_float {
    return $_[0] eq NEW_FLOAT_EXT;
}

sub is_old_float {
    return $_[0] eq FLOAT_EXT;
}

sub is_atom {
    return is_atom_ext($_[0]) || is_atom_utf8($_[0]) || is_atom_utf8_small($_[0]);
}
sub is_atom_ext {
    return $_[0] eq ATOM_EXT;
}
sub is_atom_utf8 {
    return $_[0] eq ATOM_UTF8_EXT;
}
sub is_atom_utf8_small {
    return $_[0] eq SMALL_ATOM_UTF8_EXT;
}
