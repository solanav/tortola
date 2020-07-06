defmodule Tortola.MixProject do
  use Mix.Project

  def project do
    [
      app: :tortola,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        prod: [
          include_executables_for: [:windows],
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Tortola, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:myxql, "~> 0.3.0"}, # Database access
      {:quantum, "~> 3.0"}, # Crontab
      {:tz, "~> 0.10.0"}, # Timezone database
      {:logger_file_backend, "~> 0.0.11"}
    ]
  end
end
