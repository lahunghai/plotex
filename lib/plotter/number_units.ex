defmodule Plotter.NumberUnits do
  require Logger

  @number_basis [1, 2, 5, 10, 20, 50, 100]

  @doc """
  Get units for a given date range, using the number of ticks.

  """
  def units_for(x_a, x_b, opts \\ []) do
    abs(x_a - x_b)
    |> optimize_units(opts)
  end

  @spec range_from(Enumerable.t()) :: {Number.t(), Number.t()}
  def range_from(data) do
    a = Enum.min(data)
    b = Enum.max(data)

    {a, b}
  end

  def number_scale(x_a, x_b, opts) do
    %{basis: basis} = _units = units_for(x_a, x_b, opts)
    # Logger.warn("x_basis: #{inspect units}")

    # stride = round(basis_count / Keyword.get(opts, :ticks, 10))
    # Logger.warn("x_stride: #{inspect(stride)}")
    # Logger.warn("x_a: #{x_a}")
    # Logger.warn("x_fmod: #{inspect :math.fmod(x_a, basis)}")

    x_start =
      unless x_a < 0.0 do
        trunc( x_a / basis ) * basis
      else
        trunc( x_a / basis ) * basis - basis
      end

    # x_start = x_a - :math.fmod(x_a, basis)
    x_stop = x_b + basis

    # Logger.warn("x_start: #{inspect x_start}")

    0..1_000_000_000
    |> Stream.map(fn i -> x_start + i * basis end)
    |> Stream.take_while(fn x -> x < x_stop end)
  end

  @spec optimize_units(number(), keyword()) :: %{basis: float(), rank: integer(), val: number()}
  def optimize_units(xdiff, opts \\ []) do
    count = Keyword.get(opts, :ticks, 10)

    r = rank(xdiff, count)
    # Logger.warn("rank: #{inspect r}")
    b = find_basis(xdiff, r, count)
    # Logger.warn("basis: #{inspect b}")
    %{val: xdiff, rank: r, basis: :math.pow(10, r) * b}
  end

  def find_basis(x, rank, count) do
    @number_basis
    |> Enum.map(&{&1, x / (&1 * :math.pow(count, 1 * rank))})
    |> Enum.min_by(fn {_base, val} -> abs(count - val) end)
    |> elem(0)
  end

  @doc """
  Calculate the base-10 rank of a number.
  """
  def rank(x, b), do: trunc(:math.log10(x / b) - 1)
end
