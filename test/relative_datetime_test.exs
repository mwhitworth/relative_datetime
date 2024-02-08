defmodule RelativeDateTimeTest do
  use ExUnit.Case, async: true

  import RelativeDateTime, only: [parse: 2]

  @now ~U[2018-01-01 00:00:00Z]

  test "parses relative dates without given datetime" do
    assert {:ok, ~U[2018-01-01 00:00:00Z]} = parse("now", @now)
    assert {:ok, ~U[2017-11-20 00:00:00Z]} = parse("6 weeks ago", @now)
    assert {:ok, ~U[2018-02-12 00:00:00Z]} = parse("6 weeks", @now)
    assert {:ok, ~U[2017-12-31 23:59:54.000000Z]} = parse("6 seconds ago", @now)
    assert {:ok, ~U[2017-12-31 23:54:00.000000Z]} = parse("6 minutes ago", @now)
    assert {:ok, ~U[2017-12-31 18:00:00.000000Z]} = parse("6 hours ago", @now)
    assert {:ok, ~U[2017-12-26 00:00:00Z]} = parse("6 days ago", @now)
    assert {:ok, ~U[2017-07-01 00:00:00Z]} = parse("6 months ago", @now)
    assert {:ok, ~U[2012-01-01 00:00:00Z]} = parse("6 years ago", @now)
  end

  test "combinations of relative dates" do
    assert {:ok, ~U[2017-12-31 23:53:54.000000Z]} = parse("6 minutes and 6 seconds ago", @now)
    assert {:ok, ~U[2017-12-31 23:53:54.000000Z]} = parse("6 minutes, 6 seconds ago", @now)
    assert {:ok, ~U[2017-12-31 23:53:54.000000Z]} = parse("6 minutes 6 seconds ago", @now)
  end

  test "returns error for unparsable datetimes" do
    assert :error = parse("nonsense", @now)
    assert :error = parse("sox weeks ago", @now)
    assert :error = parse("2018-13-01", @now)
  end

  test "parses given datetimes" do
    assert {:ok, ~U[2018-01-01 00:00:00Z]} = parse("2018-01-01", @now)
    assert {:ok, ~U[2018-06-01 12:34:56Z]} = parse("2018-06-01 12:34:56", @now)
    assert {:ok, ~U[2018-06-01 12:34:56.789Z]} = parse("2018-06-01 12:34:56.789", @now)
    assert {:ok, ~U[2018-06-01 12:34:56.789123Z]} = parse("2018-06-01 12:34:56.789123", @now)
  end

  test "temporal pronouns (days)" do
    assert {:ok, ~U[2018-01-01 00:00:00Z]} = parse("today", @now)
    assert {:ok, ~U[2017-12-31 00:00:00Z]} = parse("yesterday", @now)
    assert {:ok, ~U[2018-01-02 00:00:00Z]} = parse("tomorrow", @now)
  end

  test "temporal pronouns (days) with times" do
    assert {:ok, ~U[2018-01-01 12:00:00Z]} = parse("12:00 today", @now)
    assert {:ok, ~U[2018-01-01 00:01:00Z]} = parse("00:01 today", @now)
    assert {:ok, ~U[2018-01-01 23:01:00Z]} = parse("23:01 today", @now)
    assert {:ok, ~U[2017-12-31 12:00:00Z]} = parse("12:00 yesterday", @now)
    assert {:ok, ~U[2018-01-02 12:00:00Z]} = parse("12:00 tomorrow", @now)
    assert {:ok, ~U[2018-01-01 12:00:00Z]} = parse("12:00 today", ~U[2018-01-01 11:59:00Z])
  end
end
