defmodule Convert do 
  def to_coord ["forward", dist] do
    %{:pos => dist, :aim => 0}
  end
  def to_coord ["up", dist] do
    %{:pos => 0, :aim => -dist}
  end
  def to_coord ["down", dist] do
    %{:pos => 0, :aim => dist}
  end
end

reducer = fn coord, acc -> 
  %{:pos => coord.pos + acc.pos, 
    :depth => coord.pos * acc.aim + acc.depth, 
    :aim => coord.aim + acc.aim}
end

IO.stream(:stdio, :line)
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split/1)
  |> Enum.map(fn [dir, dist] -> [dir, String.to_integer(dist)] end)
  |> Enum.map(&Convert.to_coord/1)
  |> Enum.reduce(%{:pos => 0, :depth => 0, :aim => 0}, reducer)
  |> (&(&1.pos * &1.depth)).()
  |> IO.inspect


  