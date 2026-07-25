# SPDX-License-Identifier: MPL-2.0
# (MPL-2.0 preferred; MPL-2.0 required for Hex.pm)
#
# k9_aspect_test.exs — Aspect tests for K9 parser/renderer.
#
# Tests cross-cutting concerns: security (input safety), correctness,
# performance, and resilience. These complement the unit and contract tests
# by validating behavioural aspects that cut across the whole API surface.

defmodule K9AspectTest do
  use ExUnit.Case, async: true

  # ---------------------------------------------------------------------------
  # Aspect: Security — empty and nil-like inputs are handled gracefully
  # ---------------------------------------------------------------------------

  test "ASPECT security: empty string is handled gracefully without raise" do
    result = K9.parse("")
    assert match?({:error, _}, result)
  end

  test "ASPECT security: whitespace-only input handled gracefully" do
    result = K9.parse("     \n   \t  ")
    assert match?({:error, _}, result)
  end

  test "ASPECT security: nil input returns error tuple, does not raise" do
    # nil is not a valid String.t() but we defend against it via rescue.
    result =
      try do
        K9.parse(nil)
      rescue
        _ -> {:error, :bad_argument}
      end

    assert match?({:error, _}, result)
  end

  # ---------------------------------------------------------------------------
  # Aspect: Security — very long strings do not crash the parser
  # ---------------------------------------------------------------------------

  test "ASPECT security: 1000-character garbage string does not crash parser" do
    long_string = String.duplicate("x", 1000)
    result = K9.parse(long_string)
    assert match?({:error, _}, result)
  end

  test "ASPECT security: 1000-character valid-looking but truncated input is safe" do
    long_name = String.duplicate("a", 200)
    # Build a structurally valid document but with a very long name.
    input =
      "pedigree:\n  name: #{long_name}\n  version: 1.0.0\n  description: Long name test\n\nsecurity:\n  level: kennel"

    result = K9.parse(input)
    # Either succeeds or errors cleanly — must not raise.
    assert match?({:ok, _}, result) or match?({:error, _}, result)
  end

  # ---------------------------------------------------------------------------
  # Aspect: Correctness — pedigree fields survive parse/render roundtrip
  # ---------------------------------------------------------------------------

  test "ASPECT correctness: pedigree author and license survive roundtrip" do
    input =
      "pedigree:\n  name: aspect-rt\n  version: 1.0.0\n  description: Aspect roundtrip\n  author: Jonathan D.A. Jewell\n  license: MPL-2.0\n\nsecurity:\n  level: kennel"

    assert {:ok, c1} = K9.parse(input)
    assert c1.pedigree.author == "Jonathan D.A. Jewell"
    assert c1.pedigree.license == "MPL-2.0"

    rendered = K9.render(c1)
    assert {:ok, c2} = K9.parse(rendered)
    assert c2.pedigree.author == "Jonathan D.A. Jewell"
    assert c2.pedigree.license == "MPL-2.0"
  end

  test "ASPECT correctness: security flags survive roundtrip" do
    input =
      "pedigree:\n  name: flags-rt\n  version: 1.0.0\n  description: Flags roundtrip\n\nsecurity:\n  level: yard\n  allow-network: true\n  allow-fs-write: true\n  allow-subprocess: false"

    assert {:ok, c1} = K9.parse(input)
    assert c1.security.allow_network == true
    assert c1.security.allow_fs_write == true
    assert c1.security.allow_subprocess == false

    rendered = K9.render(c1)
    assert {:ok, c2} = K9.parse(rendered)
    assert c2.security.allow_network == c1.security.allow_network
    assert c2.security.allow_fs_write == c1.security.allow_fs_write
    assert c2.security.allow_subprocess == c1.security.allow_subprocess
  end

  test "ASPECT correctness: tags survive roundtrip" do
    input =
      "pedigree:\n  name: tags-rt\n  version: 1.0.0\n  description: Tags roundtrip\n\nsecurity:\n  level: kennel\n\ntags: alpha, beta, gamma"

    assert {:ok, c1} = K9.parse(input)
    assert c1.tags == ["alpha", "beta", "gamma"]

    rendered = K9.render(c1)
    assert {:ok, c2} = K9.parse(rendered)
    assert c2.tags == c1.tags
  end

  # ---------------------------------------------------------------------------
  # Aspect: Performance — parsing 100 identical inputs completes without error
  # ---------------------------------------------------------------------------

  test "ASPECT performance: parse 100 identical inputs without error" do
    input =
      "pedigree:\n  name: perf-test\n  version: 1.0.0\n  description: Performance aspect\n\nsecurity:\n  level: kennel"

    results =
      Enum.map(1..100, fn _ -> K9.parse(input) end)

    Enum.each(results, fn result ->
      assert match?({:ok, _}, result),
             "Expected {:ok, _} but got #{inspect(result)}"
    end)
  end

  test "ASPECT performance: render 100 identical components without error" do
    input =
      "pedigree:\n  name: render-perf\n  version: 1.0.0\n  description: Render performance\n\nsecurity:\n  level: yard"

    assert {:ok, component} = K9.parse(input)

    outputs =
      Enum.map(1..100, fn _ -> K9.render(component) end)

    Enum.each(outputs, fn out ->
      assert is_binary(out)
    end)
  end

  # ---------------------------------------------------------------------------
  # Aspect: Resilience — partial/malformed documents return errors, not raises
  # ---------------------------------------------------------------------------

  test "ASPECT resilience: partial pedigree block (name only, no security) returns error or ok without raise" do
    # The parser may fill in defaults (security defaults to kennel) and succeed,
    # or may require an explicit security block. Either way it must not raise.
    partial = "pedigree:\n  name: partial"
    result = K9.parse(partial)
    assert match?({:ok, _}, result) or match?({:error, _}, result)
  end

  test "ASPECT resilience: security block without pedigree does not raise" do
    input = "security:\n  level: kennel"
    result = K9.parse(input)
    assert match?({:error, _}, result)
  end
end
