# pErlang
Encoding and Decoding of Erlang Datastructures in Perl using the [Erlang Term Format](http://erlang.org/doc/apps/erts/erl_ext_dist.html).

## Status
Decoding of Basic types possible
* Atoms
* Binaries
* Strings aka Charlists
* Integers
* Floats (only new Float Format! look at [this](http://erlang.org/doc/apps/erts/erl_ext_dist.html#float_ext))
* Maps
* Lists
* Tuples

## Planned
* Encoding of `pErlang::` Structures back to the [Erlang Term Format](http://erlang.org/doc/apps/erts/erl_ext_dist.html)
* Converting `pErlang::` Structures into native perl structures
* Improving quality of `pErlang::` Classes 
  * Adding Operator overloading (currently only done for `pErlang::String` and `pErlang::Binary`)
* Support for Zlib-Compressed Erlang Terms
* Adding a Messageloop/Hook Module (Maybe this will be put into [ErlPort](https://github.com/hdima/erlport))
