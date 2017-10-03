defmodule GithubStargazersTest do
  use ExUnit.Case
  doctest GithubStargazers

  test "greets the world" do
    assert GithubStargazers.hello() == :world
  end
end
