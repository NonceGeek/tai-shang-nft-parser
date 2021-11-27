defmodule Utils.StringHandler do
  @doc """
    "" => ""

    "https://google.com" => "https://google.com/"

    "https://google.com/" => "https://google.com/"
  """
  def handle_url(""), do: ""
  def handle_url(url) do
    if String.at(url, -1) == "/" do
      url
    else
      url <> "/"
    end
  end
end
