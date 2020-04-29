#!perl

use warnings;
use strict;

# :all really imports ALL
# all Erlang types, Atom, Float, List, etc.
# Functions encode and decode to read and send messages
# you might just want to use :types to import the Erlang types
use pErlang::Import qw(:all);

main();

sub main {

    my ($ok, $msg) = decode(\*STDIN); # actually calls pErlang::Decode::decode()
    if($ok) {
        if($msg->isa('pErlang::Atom')) {
            if($msg eq 'ping') { # or $msg->name() # name method if atom type
                my $pong = Atom('pong');
                print encode($pong); # same as decode
            }
        }
    } else {
        #when !$ok then the second value ($msg) contains an error string
        print STDERR "There was an error decoding the message: $msg\n";
    }
}
