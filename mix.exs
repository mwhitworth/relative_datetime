defmodule RelativeDatetime.MixProject do
  use Mix.Project

  def project do
    [
      app: :relative_datetime,
      version: "0.2.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Relative datetime parser",
      aliases: aliases(),
      preferred_cli_env: [ci: :test],
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:date_time_parser, "~> 1.2"},
      {:timex, "~> 3.0"},
      {:nimble_parsec, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mwhitworth/relative_datetime"}
    ]
  end

  defp aliases do
    [
      ci: [
        "format --check-formatted",
        "credo --strict",
        "compile --warnings-as-errors --force",
        "test"
      ]
    ]
  end
end
