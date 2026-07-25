// SPDX-License-Identifier: MPL-2.0
// (MPL-2.0 preferred; MPL-2.0 required for Hex.pm)
//
// k9_gleam_property_test — Property-based tests for K9 parser/renderer.
//
// Validates determinism, idempotency, and structural invariants across
// a range of inputs without relying on external property-testing libraries.

import gleam/list
import k9_gleam/parser
import k9_gleam/renderer
import k9_gleam/types.{Hunt, Kennel, Yard}

// ---------------------------------------------------------------------------
// Property: parse is deterministic — same input always produces same output
// ---------------------------------------------------------------------------

pub fn parse_is_deterministic_test() {
  let input =
    "pedigree:\n  name: prop-test\n  version: 1.0.0\n  description: Determinism test\n\nsecurity:\n  level: kennel"

  let result1 = parser.parse(input)
  let result2 = parser.parse(input)
  assert result1 == result2
}

// ---------------------------------------------------------------------------
// Property: parse determinism over 20 calls (manual property loop)
// ---------------------------------------------------------------------------

pub fn parse_deterministic_20_calls_test() {
  let input =
    "pedigree:\n  name: loop-test\n  version: 2.0.0\n  description: Loop\n\nsecurity:\n  level: yard"

  let first = parser.parse(input)

  list.range(from: 1, to: 20)
  |> list.each(fn(_) {
    let result = parser.parse(input)
    assert result == first
  })
}

// ---------------------------------------------------------------------------
// Property: render is deterministic — same component always renders identically
// ---------------------------------------------------------------------------

pub fn render_is_deterministic_test() {
  let input =
    "pedigree:\n  name: render-prop\n  version: 1.0.0\n  description: Render\n\nsecurity:\n  level: hunt"

  let assert Ok(component) = parser.parse(input)
  let out1 = renderer.render(component)
  let out2 = renderer.render(component)
  assert out1 == out2
}

// ---------------------------------------------------------------------------
// Property: all valid security level strings round-trip
// ---------------------------------------------------------------------------

pub fn security_level_strings_roundtrip_test() {
  let assert Ok(Kennel) = parser.parse_security_level("kennel")
  let assert Ok(Yard) = parser.parse_security_level("yard")
  let assert Ok(Hunt) = parser.parse_security_level("hunt")
  assert renderer.render_security_level(Kennel) == "kennel"
  assert renderer.render_security_level(Yard) == "yard"
  assert renderer.render_security_level(Hunt) == "hunt"
}

// ---------------------------------------------------------------------------
// Property: roundtrip preserves name and security level for all levels
// ---------------------------------------------------------------------------

pub fn roundtrip_preserves_pedigree_and_level_test() {
  let cases = [
    #("kennel-test", "kennel", Kennel),
    #("yard-test", "yard", Yard),
    #("hunt-test", "hunt", Hunt),
  ]

  list.each(cases, fn(tc) {
    let #(name, level_str, expected_level) = tc
    let input =
      "pedigree:\n  name: "
      <> name
      <> "\n  version: 1.0.0\n  description: Roundtrip\n\nsecurity:\n  level: "
      <> level_str

    let assert Ok(c1) = parser.parse(input)
    let rendered = renderer.render(c1)
    let assert Ok(c2) = parser.parse(rendered)

    assert c1.pedigree.name == c2.pedigree.name
    assert c1.security.level == c2.security.level
    assert c2.security.level == expected_level
  })
}

// ---------------------------------------------------------------------------
// Property: invalid security level strings never produce Ok
// ---------------------------------------------------------------------------

pub fn invalid_security_levels_never_ok_test() {
  let invalid = [
    "none", "all", "safe", "unsafe", "admin", "root",
    "unknown", "", "kennel1", "y4rd", "h-u-n-t",
  ]

  list.each(invalid, fn(name) {
    let result = parser.parse_security_level(name)
    let assert Error(_) = result
  })
}

// ---------------------------------------------------------------------------
// Property: parse always returns Ok or Error — never a partial value
// ---------------------------------------------------------------------------

pub fn parse_returns_result_shape_test() {
  let inputs = [
    "pedigree:\n  name: a\n  version: 1.0.0\n  description: ok\n\nsecurity:\n  level: kennel",
    "",
    "garbage input %%%",
    "pedigree:\n  version: 1.0.0\n\nsecurity:\n  level: kennel",
  ]

  list.each(inputs, fn(input) {
    let result = parser.parse(input)
    case result {
      Ok(_) -> Nil
      Error(_) -> Nil
    }
  })
}
