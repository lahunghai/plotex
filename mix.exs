defmodule Plotex.MixProject do
  use Mix.Project

  def project do
    [
      app: :plotex,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    Extensible plotting library and core plotting routines written in pure Elixir.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*", "test"],
      maintainers: ["Jaremy Creechley"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/elcritch/plotex"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_html, "~> 2.13"},
      {:tzdata, "~> 1.0"},
      {:calendar, "~> 0.17.5"},

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
