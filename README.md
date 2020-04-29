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

Encoding of `pErlang::` Structures back to the [Erlang Term Format](http://erlang.org/doc/apps/erts/erl_ext_dist.html)

## Planned
* Converting `pErlang::` Structures into native perl structures
* Improving quality of `pErlang::` Classes 
  * Adding Operator overloading (currently only done for `pErlang::String` and `pErlang::Binary`)
* Support for Zlib-Compressed Erlang Terms
* Adding a Messageloop/Hook Module (Maybe this will be put into [ErlPort](https://github.com/hdima/erlport))

## Dependencies
* [Mouse](https://metacpan.org/pod/Mouse)
* [Mouse::Role](https://metacpan.org/pod/Mouse::Role)

## Examples
### Ping Pong (using elixir)
```
> cd examples/ping_pong
> ls
ping.ex  pong.pl
> iex ping.ex
Erlang/OTP 22 [erts-10.7.1] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Interactive Elixir (1.9.2) - press Ctrl+C to exit (type h() ENTER for help)
> iex(1)> Ping.ping()
{#PID<0.109.0>, {:command, <<131, 100, 0, 4, 112, 105, 110, 103>>}}
> iex(2)> Ping.do_receive
got the message: pong
:ok
```
