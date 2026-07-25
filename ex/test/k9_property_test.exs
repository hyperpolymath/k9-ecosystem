# SPDX-License-Identifier: MPL-2.0
# (MPL-2.0 preferred; MPL-2.0 required for Hex.pm)
#
# k9_property_test.exs — Property-based tests for K9 parser/renderer.
#
# Validates determinism, idempotency, and structural invariants across
# a range of inputs without relying on external property-testing libraries.

defmodule K9PropertyTest do
  use ExUnit.Case, async: true

  alias K9.Types.SecurityLevel

  # ---------------------------------------------------------------------------
  # Property: parse is deterministic — same input always produces same output
  # ---------------------------------------------------------------------------

  test "parse is deterministic over 50 identical calls" do
    input =
      "pedigree:\n  name: prop-test\n  version: 1.0.0\n  description: Determinism test\n\nsecurity:\n  level: kennel"

    results =
      Enum.map(1..50, fn _ -> K9.parse(input) end)

    first = hd(results)

    Enum.each(results, fn result ->
      assert result == first,
             "parse/1 returned different results on identical input"
    end)
  end

  # ---------------------------------------------------------------------------
  # Property: render is deterministic — rendering the same component yields
  # the same string every time
  # ---------------------------------------------------------------------------

  test "render is deterministic over 50 identical calls" do
    input =
      "pedigree:\n  name: render-prop\n  version: 2.0.0\n  description: Render prop\n\nsecurity:\n  level: yard\n  allow-network: true\n  allow-fs-write: false\n  allow-subprocess: false"

    assert {:ok, component} = K9.parse(input)

    outputs = Enum.map(1..50, fn _ -> K9.render(component) end)
    first = hd(outputs)

    Enum.each(outputs, fn out ->
      assert out == first,
             "render/1 returned different results for the same component"
    end)
  end

  # ---------------------------------------------------------------------------
  # Property: all valid security level strings round-trip through from_string/to_string
  # ---------------------------------------------------------------------------

  test "all security level strings round-trip" do
    levels = ["kennel", "yard", "hunt"]

    Enum.each(levels, fn name ->
      assert {:ok, level} = SecurityLevel.from_string(name)
      assert SecurityLevel.to_string(level) == name
    end)
  end

  # ---------------------------------------------------------------------------
  # Property: security level compare is anti-symmetric
  #           compare(a, b) == :lt  iff  compare(b, a) == :gt
  # ---------------------------------------------------------------------------

  test "security level compare is anti-symmetric" do
    pairs = [{:kennel, :yard}, {:kennel, :hunt}, {:yard, :hunt}]

    Enum.each(pairs, fn {a, b} ->
      assert SecurityLevel.compare(a, b) == :lt
      assert SecurityLevel.compare(b, a) == :gt
    end)
  end

  # ---------------------------------------------------------------------------
  # Property: security level compare is reflexive — compare(x, x) == :eq
  # ---------------------------------------------------------------------------

  test "security level compare is reflexive" do
    Enum.each([:kennel, :yard, :hunt], fn level ->
      assert SecurityLevel.compare(level, level) == :eq
    end)
  end

  # ---------------------------------------------------------------------------
  # Property: roundtrip preserves pedigree name and security level
  #           across all three security levels
  # ---------------------------------------------------------------------------

  test "roundtrip preserves pedigree name and security level for all levels" do
    Enum.each(["kennel", "yard", "hunt"], fn level_str ->
      input =
        "pedigree:\n  name: rt-#{level_str}\n  version: 1.0.0\n  description: Roundtrip #{level_str}\n\nsecurity:\n  level: #{level_str}"

      assert {:ok, c1} = K9.parse(input)
      rendered = K9.render(c1)
      assert {:ok, c2} = K9.parse(rendered)
      assert c1.pedigree.name == c2.pedigree.name
      assert c1.security.level == c2.security.level
    end)
  end

  # ---------------------------------------------------------------------------
  # Property: invalid level strings never produce :ok
  # ---------------------------------------------------------------------------

  test "invalid security level strings never return ok over 20 variants" do
    # Note: from_string/1 trims whitespace before matching, so padded valid
    # strings like "yard " resolve to :yard. The invalid list only includes
    # strings that are genuinely not recognised after trimming.
    invalid_names = [
      "none", "all", "safe", "unsafe", "admin", "root", "public",
      "private", "unknown", "nil", "", "k9", "KENNEL1", "y4rd",
      "h-u-n-t", "kENNEL!", "KennelYard", "0", "kennelyard", "hunted"
    ]

    Enum.each(invalid_names, fn name ->
      result = SecurityLevel.from_string(name)

      assert match?({:error, _}, result),
             "Expected {:error, _} for #{inspect(name)}, got #{inspect(result)}"
    end)
  end
end
