defmodule RelativeDateTime do
  @moduledoc """
  Parse a relative datetime string and return a datetime.
  """

  import NimbleParsec

  whitespace = string(" ")

  now = string("now") |> unwrap_and_tag(:now)
  ago = string("ago") |> replace(-1) |> unwrap_and_tag(:multiplier)

  number = integer(min: 1) |> unwrap_and_tag(:amount)

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

  root =
    choice([
      now,
      parsec({DateTimeParser.Combinators, :parse_datetime}),
      parsec({DateTimeParser.Combinators, :parse_datetime_us}),
      number |> ignore(whitespace) |> concat(unit) |> optional(ignore(whitespace) |> concat(ago))
    ])

  defparsec(:parse_relative_datetime, root)

  @doc """
  Parses a given relative datetime string and returns a datetime.

  iex> RelativeDateTime.parse("3 days ago", ~U[2018-01-01 00:00:00Z])
  {:ok, ~U[2017-12-29 00:00:00Z]}
  """
  @spec parse(String.t(), DateTime.t()) :: {:ok, DateTime.t()} | :error
  def parse(relative, datetime) do
    case parse_relative_datetime(relative) do
      {:ok, [now: "now"], _, _, _, _} ->
        {:ok, datetime}

      {:ok, [year: year, month: month, day: day, hour: hour, minute: minute, second: second], "",
       _, _, _} ->
        {:ok,
         Date.new!("#{year}" |> String.to_integer(), month, day)
         |> DateTime.new!(Time.new!(hour, minute, second))}

      {:ok, [year: year, month: month, day: day], "", _, _, _} ->
        {:ok,
         Date.new!("#{year}" |> String.to_integer(), month, day) |> DateTime.new!(~T[00:00:00])}

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
