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
    |> optional(ignore(string("s")))
    |> unwrap_and_tag(:unit)

  hour =
    choice([
      ignore(string("0")) |> integer(1),
      ignore(string("1")) |> integer(1) |> map({Kernel, :+, [10]}),
      ignore(string("2"))
      |> ascii_char([?0..?3])
      |> map({Kernel, :+, [20 - ?0]})
    ])
    |> map({:add_unit, [:hour]})
    |> unwrap_and_tag(:absolute_datetime)

  minute = integer(2) |> map({:add_unit, [:minute]}) |> unwrap_and_tag(:absolute_datetime)

  time_of_day = hour |> ignore(string(":")) |> concat(minute)

  relative_day_pronoun =
    choice([
      string("today") |> replace(amount: 0, unit: :days),
      string("yesterday") |> replace(amount: -1, unit: :days),
      string("tomorrow") |> replace(amount: 1, unit: :days)
    ])
    |> unwrap_and_tag(:relative_datetime)

  relative_pronoun =
    choice([
      string("last") |> replace(-1),
      string("this") |> replace(0),
      string("next") |> replace(1)
    ])
    |> unwrap_and_tag(:amount)

  relative_pronoun_and_unit =
    relative_pronoun
    |> ignore(whitespace)
    |> concat(unit)
    |> tag(:relative_datetime)

  relative_datetime_suffix = optional(ignore(whitespace) |> concat(ago))

  relative_datetime_pattern =
    number |> ignore(whitespace) |> concat(unit) |> tag(:relative_datetime)

  relative_datetime_joiner =
    choice([
      ignore(whitespace) |> ignore(string("and")) |> ignore(whitespace),
      ignore(optional(whitespace)) |> ignore(string(",")) |> ignore(whitespace),
      ignore(whitespace)
    ])

  relative_datetime =
    relative_datetime_pattern
    |> optional(relative_datetime_joiner |> concat(relative_datetime_pattern))

  time_of_day_and_relative_day_pronoun =
    time_of_day
    |> ignore(whitespace)
    |> concat(relative_day_pronoun)

  root =
    choice([
      now,
      relative_day_pronoun,
      relative_pronoun_and_unit,
      time_of_day_and_relative_day_pronoun,
      parsec({DateTimeParser.Combinators, :parse_datetime}),
      parsec({DateTimeParser.Combinators, :parse_datetime_us}),
      relative_datetime |> concat(relative_datetime_suffix)
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

      {:ok,
       [
         {:year, year},
         {:month, month},
         {:day, day},
         {:hour, hour},
         {:minute, minute},
         {:second, second} | _
       ] = args, "", _, _, _} ->
        {:ok,
         Date.new!("#{year}" |> String.to_integer(), month, day)
         |> DateTime.new!(Time.new!(hour, minute, second, microseconds(args)))}

      {:ok, [year: year, month: month, day: day], "", _, _, _} ->
        {:ok,
         Date.new!("#{year}" |> String.to_integer(), month, day) |> DateTime.new!(~T[00:00:00])}

      {:ok, args, "", _, _, _} ->
        {:ok, apply_relative_datetime(datetime, args)}

      _ ->
        :error
    end
  end

  #

  defp apply_relative_datetime(datetime, args) do
    {multiplier, args} = Keyword.pop(args, :multiplier, 1)

    for {operation, [amount: amount, unit: unit]} <- args,
        reduce: datetime do
      curr_datetime ->
        case operation do
          :relative_datetime ->
            Timex.shift(curr_datetime, [{unit, amount * multiplier}])

          :absolute_datetime ->
            Timex.set(curr_datetime, [{unit, amount}])
        end
    end
  end

  defp microseconds(time) do
    case Keyword.fetch(time, :microsecond) do
      :error ->
        {0, 0}

      {:ok, microsecond} ->
        accuracy = length(microsecond)
        multiplier = Integer.pow(10, 6 - accuracy)

        microsecond =
          microsecond |> :string.to_integer() |> elem(0) |> Kernel.*(multiplier)

        {microsecond, accuracy}
    end
  end

  defp add_unit(amount, unit) do
    [amount: amount, unit: unit]
  end
end
