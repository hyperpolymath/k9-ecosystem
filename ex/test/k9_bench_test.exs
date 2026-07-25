# SPDX-License-Identifier: MPL-2.0
# (MPL-2.0 preferred; MPL-2.0 required for Hex.pm)
#
# k9_bench_test.exs — Timing/benchmark tests for K9 parser/renderer.
#
# Uses ExUnit with wall-clock assertions to detect gross performance regressions.
# Not a microbenchmark harness — guards against orders-of-magnitude slowdowns.

defmodule K9BenchTest do
  use ExUnit.Case, async: false

  # Maximum acceptable wall-clock time (milliseconds) for the bulk operations
  # defined below. These are deliberately generous to avoid CI flakiness while
  # still catching catastrophic regressions.
  @parse_budget_ms 5_000
  @render_budget_ms 5_000
  @roundtrip_budget_ms 10_000

  # ---------------------------------------------------------------------------
  # Benchmark: parse 500 minimal components within budget
  # ---------------------------------------------------------------------------

  test "bench: parse 500 minimal components within #{@parse_budget_ms}ms" do
    input =
      "pedigree:\n  name: bench-parse\n  version: 1.0.0\n  description: Bench\n\nsecurity:\n  level: kennel"

    {elapsed_us, _results} =
      :timer.tc(fn ->
        Enum.each(1..500, fn _ -> K9.parse(input) end)
      end)

    elapsed_ms = div(elapsed_us, 1_000)

    assert elapsed_ms < @parse_budget_ms,
           "parse 500 took #{elapsed_ms}ms — exceeded #{@parse_budget_ms}ms budget"
  end

  # ---------------------------------------------------------------------------
  # Benchmark: render 500 components within budget
  # ---------------------------------------------------------------------------

  test "bench: render 500 components within #{@render_budget_ms}ms" do
    input =
      "pedigree:\n  name: bench-render\n  version: 1.0.0\n  description: Bench\n\nsecurity:\n  level: yard\n  allow-network: true\n  allow-fs-write: false\n  allow-subprocess: false"

    assert {:ok, component} = K9.parse(input)

    {elapsed_us, _results} =
      :timer.tc(fn ->
        Enum.each(1..500, fn _ -> K9.render(component) end)
      end)

    elapsed_ms = div(elapsed_us, 1_000)

    assert elapsed_ms < @render_budget_ms,
           "render 500 took #{elapsed_ms}ms — exceeded #{@render_budget_ms}ms budget"
  end

  # ---------------------------------------------------------------------------
  # Benchmark: full roundtrip (parse + render + parse) 200 times within budget
  # ---------------------------------------------------------------------------

  test "bench: 200 full roundtrips within #{@roundtrip_budget_ms}ms" do
    input =
      "pedigree:\n  name: bench-rt\n  version: 2.0.0\n  description: Roundtrip bench\n  author: Jonathan D.A. Jewell\n  license: MPL-2.0\n\nsecurity:\n  level: hunt\n  allow-network: false\n  allow-fs-write: false\n  allow-subprocess: false\n\ntags: bench, roundtrip"

    {elapsed_us, _} =
      :timer.tc(fn ->
        Enum.each(1..200, fn _ ->
          assert {:ok, c1} = K9.parse(input)
          rendered = K9.render(c1)
          assert {:ok, _c2} = K9.parse(rendered)
        end)
      end)

    elapsed_ms = div(elapsed_us, 1_000)

    assert elapsed_ms < @roundtrip_budget_ms,
           "200 roundtrips took #{elapsed_ms}ms — exceeded #{@roundtrip_budget_ms}ms budget"
  end

  # ---------------------------------------------------------------------------
  # Benchmark: security level from_string 1000 times is fast
  # ---------------------------------------------------------------------------

  test "bench: SecurityLevel.from_string 1000 calls is fast" do
    levels = ["kennel", "yard", "hunt", "KENNEL", "Yard", "HUNT"]

    {elapsed_us, _} =
      :timer.tc(fn ->
        Enum.each(1..1000, fn i ->
          level = Enum.at(levels, rem(i, length(levels)))
          K9.Types.SecurityLevel.from_string(level)
        end)
      end)

    elapsed_ms = div(elapsed_us, 1_000)

    assert elapsed_ms < 500,
           "1000 from_string calls took #{elapsed_ms}ms — expected < 500ms"
  end
end
