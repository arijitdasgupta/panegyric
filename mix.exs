defmodule Panegyric.MixProject do
  use Mix.Project

  def project do
    [
      app: :panegyric,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :redix],
      mod: {App, [:prod]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 1.0.3"},
      {:plug, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:redix, ">= 0.0.0"}
    ]
  end
end
