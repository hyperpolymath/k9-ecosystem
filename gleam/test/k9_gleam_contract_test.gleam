// SPDX-License-Identifier: MPL-2.0
// (MPL-2.0 preferred; MPL-2.0 required for Hex.pm)
//
// k9_gleam_contract_test — Contract/invariant tests for K9 parser/renderer.
//
// Tests the behavioural contracts that the API must uphold regardless of input.
// Each test validates a named invariant.

import gleam/string
import k9_gleam/parser
import k9_gleam/renderer
import k9_gleam/types.{Hunt, Kennel, Yard}

// ---------------------------------------------------------------------------
// INVARIANT: parse of empty string returns Error(EmptyInput)
// ---------------------------------------------------------------------------

pub fn invariant_parse_empty_returns_error_test() {
  let assert Error(parser.EmptyInput) = parser.parse("")
}

pub fn invariant_parse_whitespace_returns_error_test() {
  let assert Error(parser.EmptyInput) = parser.parse("   \n\t  ")
}

// ---------------------------------------------------------------------------
// INVARIANT: parse success always returns Ok(Component)
// ---------------------------------------------------------------------------

pub fn invariant_parse_valid_returns_ok_test() {
  let input =
    "pedigree:\n  name: invariant\n  version: 1.0.0\n  description: Contract\n\nsecurity:\n  level: kennel"

  let assert Ok(_component) = parser.parse(input)
}

// ---------------------------------------------------------------------------
// INVARIANT: missing pedigree.name returns MissingField error
// ---------------------------------------------------------------------------

pub fn invariant_missing_name_returns_missing_field_test() {
  let input = "pedigree:\n  version: 1.0.0\n\nsecurity:\n  level: kennel"
  let assert Error(parser.MissingField("pedigree.name")) = parser.parse(input)
}

// ---------------------------------------------------------------------------
// INVARIANT: parse_security_level returns Ok for all canonical levels
// ---------------------------------------------------------------------------

pub fn invariant_parse_security_level_ok_for_canonical_test() {
  let assert Ok(Kennel) = parser.parse_security_level("kennel")
  let assert Ok(Yard) = parser.parse_security_level("yard")
  let assert Ok(Hunt) = parser.parse_security_level("hunt")
}

// ---------------------------------------------------------------------------
// INVARIANT: parse_security_level is case-insensitive
// ---------------------------------------------------------------------------

pub fn invariant_parse_security_level_case_insensitive_test() {
  let assert Ok(Kennel) = parser.parse_security_level("KENNEL")
  let assert Ok(Kennel) = parser.parse_security_level("Kennel")
  let assert Ok(Yard) = parser.parse_security_level("YARD")
  let assert Ok(Hunt) = parser.parse_security_level("Hunt")
}

// ---------------------------------------------------------------------------
// INVARIANT: parse_security_level returns Error for unknown inputs
// ---------------------------------------------------------------------------

pub fn invariant_parse_security_level_error_for_unknown_test() {
  let assert Error(parser.UnknownSecurityLevel(_)) =
    parser.parse_security_level("invalid")
  let assert Error(parser.UnknownSecurityLevel(_)) =
    parser.parse_security_level("none")
  let assert Error(parser.UnknownSecurityLevel(_)) =
    parser.parse_security_level("")
}

// ---------------------------------------------------------------------------
// INVARIANT: render always returns a non-empty string
// ---------------------------------------------------------------------------

pub fn invariant_render_returns_non_empty_string_test() {
  let input =
    "pedigree:\n  name: render-contract\n  version: 1.0.0\n  description: Render test\n\nsecurity:\n  level: yard"

  let assert Ok(component) = parser.parse(input)
  let output = renderer.render(component)
  assert output != ""
}

// ---------------------------------------------------------------------------
// INVARIANT: rendered output contains pedigree and security sections
// ---------------------------------------------------------------------------

pub fn invariant_render_contains_pedigree_and_security_test() {
  let input =
    "pedigree:\n  name: section-check\n  version: 1.0.0\n  description: Sections\n\nsecurity:\n  level: hunt"

  let assert Ok(component) = parser.parse(input)
  let output = renderer.render(component)

  assert string.contains(output, "pedigree:")
  assert string.contains(output, "security:")
}

// ---------------------------------------------------------------------------
// INVARIANT: security level rendering is stable (no trailing whitespace)
// ---------------------------------------------------------------------------

pub fn invariant_render_security_level_no_whitespace_test() {
  assert renderer.render_security_level(Kennel) == "kennel"
  assert renderer.render_security_level(Yard) == "yard"
  assert renderer.render_security_level(Hunt) == "hunt"
}
