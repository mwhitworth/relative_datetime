# RelativeDateTime

Parses relative datetimes, given an input string and datetime:

```elixir
iex> {:ok, datetime} = RelativeDateTime.parse("3 days ago", ~U[2018-01-01 00:00:00Z])
{:ok, ~U[2018-12-29 00:00:00Z]}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `relative_datetime` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:relative_datetime, "~> 0.0.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/relative_datetime>.

