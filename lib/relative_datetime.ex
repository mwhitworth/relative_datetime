defmodule RelativeDateTime do
  @moduledoc """
  Parse a relative datetime string and return a datetime.
  """

  import NimbleParsec

  whitespace = string(" ")
  dash = string("-")

  now = string("now") |> unwrap_and_tag(:now)
  ago = string("ago") |> replace(-1) |> unwrap_and_tag(:multiplier)

  number = integer(min: 1) |> unwrap_and_tag(:amount)

  # use replace here - get rid of to_unit
  unit =
    choice([
      string("second") |> replace(:seconds),
      string("minute") |> replace(:minutes),
      string("hour") |> replace(:hours),
      string("day") |> replace(:days),
      string("week") |> replace(:weeks),
      string("month") |> replace(:months),
      string("year") |> replace(:years)
    ])
    |> ignore(string("s"))
    |> unwrap_and_tag(:unit)

  numeric_month2 =
    ~w(01 02 03 04 05 06 07 08 09 10 11 12)
    |> Enum.map(&string/1)
    |> choice()

  numeric_month1 =
    1..9
    |> Enum.map(&to_string/1)
    |> Enum.map(&string/1)
    |> choice()
    |> lookahead_not(integer(1))

  day2 =
    (~w(01 02 03 04 05 06 07 08 09) ++ Enum.map(10..31, &to_string/1))
    |> Enum.map(&string/1)
    |> choice()

  day1 =
    1..9
    |> Enum.map(&to_string/1)
    |> Enum.map(&string/1)
    |> choice()
    |> lookahead_not(integer(1))

  # return integer
  year =
    [?0..?9]
    |> ascii_char()
    |> times(4)
    |> reduce({:++, [[]]})
    |> map({Kernel, :to_string, []})
    |> map({String, :to_integer, []})
    |> unwrap_and_tag(:year)

  # return intger
  month =
    choice([numeric_month2, numeric_month1])
    |> map({String, :to_integer, []})
    |> unwrap_and_tag(:month)

  day =
    choice([
      day2,
      day1
    ])
    |> map({String, :to_integer, []})
    |> unwrap_and_tag(:day)

  root =
    choice([
      now,
      year |> ignore(dash) |> concat(month) |> ignore(dash) |> concat(day),
      number |> ignore(whitespace) |> concat(unit) |> optional(ignore(whitespace) |> concat(ago))
    ])

  defparsec(:parse_datetime, root)

  @doc """
  Parses a given relative datetime string and returns a datetime.
  """
  def parse(relative, datetime) do
    case parse_datetime(relative) do
      {:ok, [now: "now"], _, _, _, _} ->
        {:ok, datetime}

      {:ok, [year: year, month: month, day: day], "", _, _, _} ->
        {:ok, Date.new!(year, month, day) |> DateTime.new!(~T[00:00:00])}

      {:ok, args, "", _, _, _} ->
        {:ok, apply_relative_datetime(datetime, Map.new(args))}

      _ ->
        :error
    end
  end

  #

  defp apply_relative_datetime(datetime, %{amount: amount, unit: unit} = args) do
    datetime
    |> Timex.shift([{unit, amount * Map.get(args, :multiplier, 1)}])
  end
end
