# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaiShangNftParser.Repo.insert!(%TaiShangNftParser.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TaiShangNftParser.{ImgResources, ParserTypes}
alias TaiShangNftParser.Users.User
alias TaiShangNftParser.{Contracts, ContractTypes, ParserRules}

# init svg_resources

svg_resources =
  [
    %{
      name: "house_yellow",
      unique_id: 10001,
      description: "an little yellow house",
      img_source: "svg_resources/house_yellow.svg"},
    %{
      name: "house_red",
      unique_id: 10002,
      description: "an little red house",
      img_source: "svg_resources/house_red.svg"},
    %{
      name: "house_black",
      unique_id: 10003,
      description: "an little black house",
      img_source: "svg_resources/house_black.svg"},
    %{
      name: "house_green",
      unique_id: 10004,
      description: "an little green house",
      img_source: "svg_resources/house_green.svg"},
    %{
      name: "ground_soil",
      unique_id: 20001,
      description: "soil ground",
      img_source: "svg_resources/ground_soil.svg"},
    %{
      name: "ground_sea",
      unique_id: 20002,
      description: "sea",
      img_source: "svg_resources/ground_sea.svg"},
    %{
      name: "ground_grass",
      unique_id: 20003,
      description: "grass ground",
      img_source: "svg_resources/ground_grass.svg"},
    %{
      name: "sky_moon",
      unique_id: 30001,
      description: "orange shoes",
      img_source: "svg_resources/sky_moon.svg"},
    %{
      name: "sky_sun",
      unique_id: 30002,
      description: "blue shoes",
      img_source: "svg_resources/sky_sun.svg"},
    %{
      name: "sky_cloud",
      unique_id: 30003,
      description: "pink shoes",
      img_source: "svg_resources/sky_cloud.svg"},
    %{
      name: "slogan_wow",
      unique_id: 40001,
      description: "wow",
      img_source: "svg_resources/slogan_wow.svg"},
    %{
      name: "slogan_amazing",
      unique_id: 40002,
      description: "amazing",
      img_source: "svg_resources/slogan_amazing.svg"},
    %{
      name: "slogan_cool_guy",
      unique_id: 40003,
      description: "cool guy",
      img_source: "svg_resources/slogan_cool_guy.svg"},
]

Enum.each(svg_resources, fn svg ->
  ImgResources.create(svg)
end)

# ========

example_svg =
  Utils.FileHandler.read(:bin, "example_nft.uri")
{:ok, %{id: id}} = ContractTypes.create(
  %{
    name: "n",
    description: "the n project",
    handler: "NHandler",
    example_svg: example_svg
  }
)

# ========
parser_type =
  %{
    contract_types_id: id,
    name: "bewater",
    unique_id: "78a8600956af0b56cd53b1ea68e9a3f32623e47d5d",
    resources:
      %{
        background: %{collection: [10001], x: 0, y: 0, height: 385, width: 380},
        first: %{collection: [20001,20001,20001,20001,20002,20002,20002,20002,20003,20003,20003,0], x: 229, y: 75 , height: 100, width: 100}, # hat
        second: %{collection: [30001,30001,30001,30001,30002,30002,30002,30002,30003,30003,30003, 0], x: 160, y: 260, height: 100, width: 100}, # shoes
        third: %{collection: [50001,50001,50001,50001,50002,50002,50002,50002,50003,50003,50003, 0], x: 200, y: 150, height: 100, width: 100}, # hand
        fourth: %{collection: [40001,40001,40001,40001,40001,40001,40001,40001,40001,40001,40001, 40001], x: 130, y: 0, height: 100, width: 150}, #slogan
        fifth: %{collection: [], x: 5, y: 5, height: 100, width: 100},
        sixth: %{collection: [], x: 5, y: 5, height: 100, width: 100},
        seventh: %{collection: [], x: 5, y: 5, height: 100, width: 100},
        eighth: %{collection: [], x: 5, y: 5, height: 100, width: 100},
      }
  }

ParserTypes.create(parser_type)

# ========

Contracts.create(
  %{
    name: "basic N",
    description: "basic N",
    contract_types_id: id,
    code_url: "https://github.com/WeLightProject/tai-shang-nft-contracts/tree/feat/basic_n"
  })

Contracts.create(
  %{
    name: "N with whitelist",
    description: "N with whitelist",
    contract_types_id: id,
    code_url: "https://github.com/WeLightProject/tai-shang-nft-contracts/tree/feat/whitelist_n"
  })

# ========

# !important: for Test!Ano it when using in production env
User.create("leeduckgo@l.com", "1234567890", "admin")
User.create("leeduckgo2@l.com", "1234567890")
