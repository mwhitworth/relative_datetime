defmodule RelativeDateTimeTest do
  use ExUnit.Case, async: true

  @now ~U[2018-01-01 00:00:00Z]

  test "parses relative dates without given datetime" do
    assert {:ok, ~U[2018-01-01 00:00:00Z]} = RelativeDateTime.parse("now", @now)
    assert {:ok, ~U[2017-11-20 00:00:00Z]} = RelativeDateTime.parse("6 weeks ago", @now)
    assert {:ok, ~U[2018-02-12 00:00:00Z]} = RelativeDateTime.parse("6 weeks", @now)
    assert {:ok, ~U[2017-12-31 23:59:54.000000Z]} = RelativeDateTime.parse("6 seconds ago", @now)
    assert {:ok, ~U[2017-12-31 23:54:00.000000Z]} = RelativeDateTime.parse("6 minutes ago", @now)
    assert {:ok, ~U[2017-12-31 18:00:00.000000Z]} = RelativeDateTime.parse("6 hours ago", @now)
    assert {:ok, ~U[2017-12-26 00:00:00Z]} = RelativeDateTime.parse("6 days ago", @now)
    assert {:ok, ~U[2017-07-01 00:00:00Z]} = RelativeDateTime.parse("6 months ago", @now)
    assert {:ok, ~U[2012-01-01 00:00:00Z]} = RelativeDateTime.parse("6 years ago", @now)
    assert :error = RelativeDateTime.parse("nonsense", @now)
    assert {:ok, ~U[2018-01-01 00:00:00Z]} = RelativeDateTime.parse("2018-01-01", @now)

    # Not yet supported
    assert {:ok, ~U[2018-06-01 12:34:56Z]} = RelativeDateTime.parse("2018-06-01 12:34:56", @now)
  end
end
