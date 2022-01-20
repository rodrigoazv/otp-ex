defmodule Metex.Worker do

  def loop do
    receive do
      {sender_pid, val} ->
        send(sender_pid, {:ok, temperatureTimeout(val)})
      _ ->
        IO.puts("noway")
    end

  end

  def temperatureTimeout(val) do
    receive do
    after 5000 ->
        "#{val} ----- P ------"
    end

  end

  def noTimeout(val) do
    coordinator_pid =
      spawn(Metex.Coordinator, :loop, [[], Enum.count(val)])

    val |> Enum.each(fn v ->
      worker_pid = spawn(Metex.Worker, :loop, [])
      send worker_pid, {coordinator_pid, v}
    end)

  end
end
