# SPDX-License-Identifier: MPL-2.0
# (MPL-2.0 preferred; MPL-2.0 required for Hex.pm)
#
# k9_contract_test.exs — Contract/invariant tests for K9 parser/renderer.
#
# Tests the behavioural contracts that the API must uphold regardless of input.
# Each test validates a named invariant.

defmodule K9ContractTest do
  use ExUnit.Case, async: true

  alias K9.Types.SecurityLevel

  # ---------------------------------------------------------------------------
  # INVARIANT: parse error returns {:error, _} — never raises
  # ---------------------------------------------------------------------------

  test "INVARIANT: parse of empty string returns {:error, :empty_input}" do
    assert {:error, :empty_input} = K9.parse("")
  end

  test "INVARIANT: parse of whitespace-only string returns {:error, :empty_input}" do
    assert {:error, :empty_input} = K9.parse("   \n\t  ")
  end

  test "INVARIANT: parse of garbage input returns {:error, _} not raise" do
    garbage_inputs = [
      "%%%!!!", "12345", "null", "true", "[]", "{}", "---"
    ]

    Enum.each(garbage_inputs, fn input ->
      result = K9.parse(input)

      assert match?({:error, _}, result),
             "Expected {:error, _} for #{inspect(input)}, got #{inspect(result)}"
    end)
  end

  # ---------------------------------------------------------------------------
  # INVARIANT: parse success always returns {:ok, %K9.Types.Component{}}
  # ---------------------------------------------------------------------------

  test "INVARIANT: successful parse always returns {:ok, Component}" do
    valid_input =
      "pedigree:\n  name: invariant-test\n  version: 1.0.0\n  description: Contract\n\nsecurity:\n  level: kennel"

    assert {:ok, %K9.Types.Component{}} = K9.parse(valid_input)
  end

  # ---------------------------------------------------------------------------
  # INVARIANT: valid K9 input always parses successfully
  # ---------------------------------------------------------------------------

  test "INVARIANT: minimal valid document always produces {:ok, _}" do
    minimal =
      "pedigree:\n  name: valid\n  version: 0.0.1\n  description: Minimal\n\nsecurity:\n  level: kennel"

    assert {:ok, _} = K9.parse(minimal)
  end

  # ---------------------------------------------------------------------------
  # INVARIANT: missing required pedigree.name always returns {:error, {:missing_field, _}}
  # ---------------------------------------------------------------------------

  test "INVARIANT: missing pedigree name always returns missing_field error" do
    input = "pedigree:\n  version: 1.0.0\n\nsecurity:\n  level: kennel"
    assert {:error, {:missing_field, "pedigree.name"}} = K9.parse(input)
  end

  # ---------------------------------------------------------------------------
  # INVARIANT: SecurityLevel.from_string returns {:ok, atom} for all valid levels
  # ---------------------------------------------------------------------------

  test "INVARIANT: from_string returns {:ok, atom} for all canonical level names" do
    assert {:ok, :kennel} = SecurityLevel.from_string("kennel")
    assert {:ok, :yard} = SecurityLevel.from_string("yard")
    assert {:ok, :hunt} = SecurityLevel.from_string("hunt")
  end

  # ---------------------------------------------------------------------------
  # INVARIANT: SecurityLevel.from_string is case-insensitive
  # ---------------------------------------------------------------------------

  test "INVARIANT: from_string is case-insensitive" do
    assert {:ok, :kennel} = SecurityLevel.from_string("KENNEL")
    assert {:ok, :kennel} = SecurityLevel.from_string("Kennel")
    assert {:ok, :yard} = SecurityLevel.from_string("YARD")
    assert {:ok, :hunt} = SecurityLevel.from_string("Hunt")
  end

  # ---------------------------------------------------------------------------
  # INVARIANT: SecurityLevel.from_string returns {:error, :unknown_security_level}
  #            for unknown inputs — never {:ok, _}
  # ---------------------------------------------------------------------------

  test "INVARIANT: invalid level string never returns {:ok, _}" do
    assert {:error, :unknown_security_level} = SecurityLevel.from_string("invalid")
    assert {:error, :unknown_security_level} = SecurityLevel.from_string("none")
    assert {:error, :unknown_security_level} = SecurityLevel.from_string("")
  end

  # ---------------------------------------------------------------------------
  # INVARIANT: render always returns a String, never nil or raises
  # ---------------------------------------------------------------------------

  test "INVARIANT: render always returns a binary string" do
    input =
      "pedigree:\n  name: render-contract\n  version: 1.0.0\n  description: Render test\n\nsecurity:\n  level: yard"

    assert {:ok, component} = K9.parse(input)
    output = K9.render(component)
    assert is_binary(output)
    assert byte_size(output) > 0
  end

  # ---------------------------------------------------------------------------
  # INVARIANT: rendered output contains pedigree and security sections
  # ---------------------------------------------------------------------------

  test "INVARIANT: rendered output always includes pedigree and security sections" do
    input =
      "pedigree:\n  name: section-check\n  version: 1.0.0\n  description: Section test\n\nsecurity:\n  level: hunt"

    assert {:ok, component} = K9.parse(input)
    output = K9.render(component)
    assert output =~ "pedigree:"
    assert output =~ "security:"
  end
end
