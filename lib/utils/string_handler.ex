defmodule Utils.StringHandler do
  def handle_url(url) do
    if String.at(url, -1) == "/" do
      url
    else
      url <> "/"
    end
  end
end
