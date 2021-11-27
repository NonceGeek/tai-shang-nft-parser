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
      name: "fish",
      unique_id: 10001,
      description: "fish",
      img_source: "svg_resources/bewater_flowing.gif"},
    %{
      name: "hat_white",
      unique_id: 20001,
      description: "white hat",
      img_source: "svg_resources/hat_white.svg"},
    %{
      name: "hat_yellow",
      unique_id: 20002,
      description: "yellow hat",
      img_source: "svg_resources/hat_yellow.svg"},
    %{
      name: "hat_pink",
      unique_id: 20003,
      description: "pink hat",
      img_source: "svg_resources/hat_pink.svg"},
    %{
      name: "shoes_orange",
      unique_id: 30001,
      description: "orange shoes",
      img_source: "svg_resources/shoes_orange.svg"},
    %{
      name: "shoes_blue",
      unique_id: 30002,
      description: "blue shoes",
      img_source: "svg_resources/shoes_blue.svg"},
    %{
      name: "shoes_pink",
      unique_id: 30003,
      description: "pink shoes",
      img_source: "svg_resources/shoes_pink.svg"},
    %{
      name: "slogan",
      unique_id: 40001,
      description: "slogan",
      img_source: "svg_resources/slogan.svg"},
    %{
      name: "thumb",
      unique_id: 50001,
      description: "thumb up",
      img_source: "svg_resources/hand_zan.svg"},
    %{
      name: "hand_finger_gun",
      unique_id: 50002,
      description: "hand finger gun",
      img_source: "svg_resources/hand_gun.svg"},
    %{
      name: "hand_gun",
      unique_id: 50003,
      description: "gun",
      img_source: "svg_resources/hand_gun_2.svg"},
]

Enum.each(svg_resources, fn svg ->
  ImgResources.create(svg)
end)

parser_type =
  %{
    name: "satofish",
    unique_id: 1,
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

ParserRules.create(
  %{
    unique_id: 1,
    description: "bewater",
    object_to_resource:
    %{
      background: [10001],
      first: [20001,20001,20001,20001,20002,20002,20002,20002,20003,20003,20003,0],
      second: [30001,30001,30001,30001,30002,30002,30002,30002,30003,30003,30003, 0],
      third: [50001,50001,50001,50001,50002,50002,50002,50002,50003,50003,50003, 0],
      fourth: [40001,40001,40001,40001,40001,40001,40001,40001,40001,40001,40001, 40001]

    },
    contract_types_id: id,
  })

# !important: for Test!Ano it when using in production env
User.create("leeduckgo@l.com", "1234567890", "admin")
User.create("leeduckgo2@l.com", "1234567890")
