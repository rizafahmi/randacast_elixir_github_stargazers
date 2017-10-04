defmodule GithubStargazers.Minion do
  def loop do
    receive do
      {sender_pid, username} ->
        send(sender_pid, {:ok, get_stats(username)})
      _ ->
        IO.puts("Don't know how to process this message.")
    end
    loop()
  end
  def get_stats(username) do
    result = url_for(username) |> HTTPoison.get() |> parse_response()

    case result do
      {:ok, name, followers, following} ->
        "#{username}: #{name} follows #{following}, got #{followers} follower(s)."
      :error ->
        "#{username} not found, sorry."
    end
  end

  def url_for(username) do
    url = URI.encode(username)
    "https://api.github.com/users/#{url}"
  end

  def parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> get_followers
  end

  def parse_response(_) do
    :error
  end

  def get_followers(json) do
    {:ok, json["name"], json["followers"], json["following"]}
  end
end
