defmodule DistributedNodes do
  @moduledoc """
  Documentation for DistributedNodes.
  """

  @doc """
  Hello world.

  ## Examples

      iex> DistributedNodes.hello
      :world

  """
  def hello do
    :world
  end

  def say_hello do
    IO.puts "hello from #{Node.self()}"
  end

  def start do

  end
end
