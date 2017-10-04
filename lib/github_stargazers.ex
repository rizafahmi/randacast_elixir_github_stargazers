defmodule GithubStargazers do
  def get_stars(stars) do
    coordinator_pid = spawn(GithubStargazers.Gru, :loop, [[], Enum.count(stars)])

    stars |> Enum.each(fn star -> 
      worker_pid = spawn(GithubStargazers.Minion, :loop, [])
      send(worker_pid, {coordinator_pid, star})
    end)
  end
end
