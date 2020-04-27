#!perl

use warnings;
use strict;

use pErlang::Atom;
use pErlang::Decode;


run();

sub run {
    my $stream = \*STDIN;
    my ($ok, $msg) = pErlang::Decode::decode($stream);
    if($ok) {
        if($msg->isa('pErlang::Atom')) {
            # Answer with "ok" atom
            # Every message needs to have the prefix "131" or \x83 in hex
            # If you want to encode complex structures (and complete messages) you should look at pErlang::Encode
            print "\x83".pErlang::Atom->new(name => 'ok')->encode();
        } else {
            print STDERR "This program expects an atom!\n";
        }
    } else {
        print STDERR "Error $msg\n";
    }
}
