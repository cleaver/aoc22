defmodule Y2022.D4.Parser do
  import NimbleParsec

  range =
    integer(min: 1, max: 5)
    |> ignore(string("-"))
    |> integer(min: 1, max: 5)

  defparsec(:elf_assignment, range |> ignore(string(",")) |> concat(range))
end

