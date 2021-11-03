defmodule ExqueueTest do
  use ExUnit.Case
  doctest Exqueue

  test "greets the world" do
    assert Exqueue.hello() == :world
  end
end
