#!perl

use warnings;
use strict;

use Erlang::Atom;
use Erlang::Decode;


run();

sub run {
    my $stream = \*STDIN;
    my ($ok, $msg) = Erlang::Decode::decode($stream);
    if($ok) {
        if($msg->isa('Erlang::Atom')) {
            # Answer with "ok" atom
            # Every message needs to have the prefix "131" or \x83 in hex
            # If you want to encode complex structures (and complete messages) you should look at Erlang::Encode
            print "\x83".Erlang::Atom->new(name => 'ok')->encode();
        } else {
            print STDERR "This program expects an atom!\n";
        }
    } else {
        print STDERR "Error $msg\n";
    }
}
