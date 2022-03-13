defmodule Utils.ArweaveNode do
  def get_node() do
    Application.fetch_env!(:tai_shang_nft_parser, :arweave)
  end

  def get_explorer() do
    Application.fetch_env!(:tai_shang_nft_parser, :arweave_explorer)
  end
end
