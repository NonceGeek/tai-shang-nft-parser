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

# init svg_resources

svg_resources =
  [
    %{
      name: "fish",
      unique_id: 10001,
      description: "鱼",
      img_source: "svg_resources/bewater_flowing.gif"},
    %{
      name: "hat_white",
      unique_id: 20001,
      description: "帽子",
      img_source: "svg_resources/hat_white.svg"},
    %{
      name: "hat_yellow",
      unique_id: 20002,
      description: "帽子",
      img_source: "svg_resources/hat_yellow.svg"},
    %{
      name: "hat_pink",
      unique_id: 20003,
      description: "帽子",
      img_source: "svg_resources/hat_pink.svg"},
    %{
      name: "shoes_orange",
      unique_id: 30001,
      description: "鞋子",
      img_source: "svg_resources/shoes_orange.svg"},
    %{
      name: "shoes_blue",
      unique_id: 30002,
      description: "鞋子",
      img_source: "svg_resources/shoes_blue.svg"},
    %{
      name: "shoes_pink",
      unique_id: 30003,
      description: "鞋子",
      img_source: "svg_resources/shoes_pink.svg"},
    %{
      name: "slogan",
      unique_id: 40001,
      description: "标语",
      img_source: "svg_resources/slogan.svg"},
    %{
      name: "hand_zan",
      unique_id: 50001,
      description: "点赞",
      img_source: "svg_resources/hand_zan.svg"},
    %{
      name: "hand_gun",
      unique_id: 50002,
      description: "手指手枪",
      img_source: "svg_resources/hand_gun.svg"},
    %{
      name: "hand_gun",
      unique_id: 50003,
      description: "手枪",
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
