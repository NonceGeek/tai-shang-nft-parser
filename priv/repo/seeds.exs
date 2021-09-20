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
    name: "gun",
    unique_id: 1,
    description: "一把小手枪",
    img_source: "svg_resources/handgun.svg"},
    %{
      name: "hat",
      unique_id: 2,
      description: "帽子",
      img_source: "svg_resources/hat.svg"},
    %{
      name: "shoes",
      unique_id: 3,
      description: "鞋子",
      img_source: "svg_resources/shoes.svg"},
    %{
      name: "fish",
      unique_id: 4,
      description: "鱼",
      img_source: "svg_resources/fish.svg"},

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
        background: %{collection: [4], x: 1, y: 1, height: 500, width: 500},
        first: %{collection: [1,2,3,1,2,3,1,2,3,1,2,3], x: 5, y: 5 , height: 100, width: 100},
        second: %{collection: [1,2,3,1,2,3,1,2,3,1,2,3], x: 5, y: 5, height: 100, width: 100},
        third: %{collection: [1,2,3,1,2,3,1,2,3,1,2,3], x: 5, y: 5, height: 100, width: 100},
        fourth: %{collection: [1,2,3,1,2,3,1,2,3,1,2,3], x: 5, y: 5, height: 100, width: 100},
        fifth: %{collection: [1,2,3,1,2,3,1,2,3,1,2,3], x: 5, y: 5, height: 100, width: 100},
        sixth: %{collection: [1,2,3,1,2,3,1,2,3,1,2,3], x: 5, y: 5, height: 100, width: 100},
        seventh: %{collection: [1,2,3,1,2,3,1,2,3,1,2,3], x: 5, y: 5, height: 100, width: 100},
        eighth: %{collection: [1,2,3,1,2,3,1,2,3,1,2,3], x: 5, y: 5, height: 100, width: 100},
      }
  }

ParserTypes.create(parser_type)
