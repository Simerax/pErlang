defmodule Ping do

  def spawn_port(perl_exe) do
    Port.open({:spawn_executable, perl_exe}, args: ["-I../../lib", "pong.pl"])
  end

  def ping(perl_exe \\ "perl") do
    port = spawn_port(perl_exe)
    msg = :erlang.term_to_binary(:ping)
    port |> send({self(), {:command, msg}})
  end

  def do_receive() do
    receive do
      {_port, {:data, blob}} ->
        msg = blob |> :erlang.list_to_binary() |> :erlang.binary_to_term()
        IO.puts("got the message: #{msg}")
    end
  end
end
