package Erlang::MessageHandler;
use Try::Tiny;

use Erlang::Type qw(:all);
use Erlang::Atom;


sub start {
    while(1) {
        my $msg = decode_message();
        if($msg->isa('Erlang::Atom') && $msg eq 'ex_perl_shutdown') {
            my $reply = Erlang::Atom->new(name => 'ok_lets_do_it')->encode();
            $reply = "\x83".$reply;
            print STDOUT $reply;
            msg("goodybe");
            last;
        } else {
            msg("got a message");
        }
    }
}

sub decode_message {
    my $prefix;
    sysread(STDIN, $prefix, 1);
    if($prefix ne "\x83") {
        die "wrong prefix";
    } else {
        msg("prefix is good");
    }
    return decode_term();
}

sub msg {
    print STDERR join(" ", @_)."\n\r";
}

sub decode_term {
    my $decoded;
    my $type;
    sysread(STDIN, $type, 1);

    if(is_atom($type)) {
        my $len;
        sysread(STDIN, $len, 2);
        $len = unpack("n", $len);
        my $atom_name;
        sysread(STDIN, $atom_name, $len);
        return Erlang::Atom->new(
            name => $atom_name,
            is_utf8 => 0,
        );
    }
}

1;
