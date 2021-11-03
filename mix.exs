defmodule Exqueue.MixProject do
  use Mix.Project

  def project do
    [
      app: :exqueue,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # lager is the erlang package used by the rabbitmq
      extra_applications: [:lager, :logger],
      mod: {Exqueue.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:broadway, "~> 1.0.1"},
      {:broadway_rabbitmq, "~> 0.7.0"}
    ]
  end
end
