// SPDX-License-Identifier: MPL-2.0
// (MPL-2.0 preferred; MPL-2.0 required for Hex.pm)
//
// k9_gleam_aspect_test — Aspect tests for K9 parser/renderer.
//
// Tests cross-cutting concerns: security (input safety), correctness,
// performance, and resilience. These complement the unit and contract tests
// by validating behavioural aspects that cut across the whole API surface.

import gleam/list
import gleam/string
import k9_gleam/parser
import k9_gleam/renderer

// ---------------------------------------------------------------------------
// Aspect: Security — empty and whitespace inputs are handled gracefully
// ---------------------------------------------------------------------------

pub fn aspect_security_empty_input_test() {
  let assert Error(_) = parser.parse("")
}

pub fn aspect_security_whitespace_only_test() {
  let assert Error(_) = parser.parse("     \n   \t  ")
}

// ---------------------------------------------------------------------------
// Aspect: Security — very long strings do not panic the parser
// ---------------------------------------------------------------------------

pub fn aspect_security_long_string_test() {
  let long = string.repeat("x", 1000)
  let result = parser.parse(long)
  // Must not panic — either Ok or Error is acceptable.
  case result {
    Ok(_) -> Nil
    Error(_) -> Nil
  }
}

pub fn aspect_security_long_name_field_test() {
  let long_name = string.repeat("a", 200)
  let input =
    "pedigree:\n  name: "
    <> long_name
    <> "\n  version: 1.0.0\n  description: Long name\n\nsecurity:\n  level: kennel"
  let result = parser.parse(input)
  case result {
    Ok(_) -> Nil
    Error(_) -> Nil
  }
}

// ---------------------------------------------------------------------------
// Aspect: Correctness — pedigree author and license survive roundtrip
// ---------------------------------------------------------------------------

pub fn aspect_correctness_author_license_roundtrip_test() {
  let input =
    "pedigree:\n  name: aspect-rt\n  version: 1.0.0\n  description: Aspect roundtrip\n  author: Jonathan D.A. Jewell\n  license: MPL-2.0\n\nsecurity:\n  level: kennel"

  let assert Ok(c1) = parser.parse(input)
  assert c1.pedigree.author == Ok("Jonathan D.A. Jewell")
  assert c1.pedigree.license == Ok("MPL-2.0")

  let rendered = renderer.render(c1)
  let assert Ok(c2) = parser.parse(rendered)
  assert c2.pedigree.author == Ok("Jonathan D.A. Jewell")
  assert c2.pedigree.license == Ok("MPL-2.0")
}

pub fn aspect_correctness_security_flags_roundtrip_test() {
  let input =
    "pedigree:\n  name: flags-rt\n  version: 1.0.0\n  description: Flags\n\nsecurity:\n  level: yard\n  allow-network: true\n  allow-fs-write: true\n  allow-subprocess: false"

  let assert Ok(c1) = parser.parse(input)
  assert c1.security.allow_network == True
  assert c1.security.allow_fs_write == True
  assert c1.security.allow_subprocess == False

  let rendered = renderer.render(c1)
  let assert Ok(c2) = parser.parse(rendered)
  assert c2.security.allow_network == c1.security.allow_network
  assert c2.security.allow_fs_write == c1.security.allow_fs_write
  assert c2.security.allow_subprocess == c1.security.allow_subprocess
}

pub fn aspect_correctness_tags_roundtrip_test() {
  let input =
    "pedigree:\n  name: tags-rt\n  version: 1.0.0\n  description: Tags\n\nsecurity:\n  level: kennel\n\ntags: alpha, beta, gamma"

  let assert Ok(c1) = parser.parse(input)
  assert c1.tags == ["alpha", "beta", "gamma"]

  let rendered = renderer.render(c1)
  let assert Ok(c2) = parser.parse(rendered)
  assert c2.tags == c1.tags
}

// ---------------------------------------------------------------------------
// Aspect: Performance — parsing 100 identical inputs completes without error
// ---------------------------------------------------------------------------

pub fn aspect_performance_parse_100_identical_test() {
  let input =
    "pedigree:\n  name: perf-test\n  version: 1.0.0\n  description: Performance\n\nsecurity:\n  level: kennel"

  list.range(from: 1, to: 100)
  |> list.each(fn(_) {
    let assert Ok(_) = parser.parse(input)
  })
}

pub fn aspect_performance_render_100_identical_test() {
  let input =
    "pedigree:\n  name: render-perf\n  version: 1.0.0\n  description: Render performance\n\nsecurity:\n  level: yard"

  let assert Ok(component) = parser.parse(input)

  list.range(from: 1, to: 100)
  |> list.each(fn(_) {
    let out = renderer.render(component)
    assert out != ""
  })
}

// ---------------------------------------------------------------------------
// Aspect: Resilience — partial/malformed inputs return errors without panic
// ---------------------------------------------------------------------------

pub fn aspect_resilience_security_only_no_pedigree_test() {
  let input = "security:\n  level: kennel"
  let result = parser.parse(input)
  // Without a pedigree section the parser may fail with MissingField — acceptable.
  case result {
    Ok(_) -> Nil
    Error(_) -> Nil
  }
}

pub fn aspect_resilience_partial_security_level_test() {
  let input =
    "pedigree:\n  name: partial\n  version: 1.0.0\n  description: Partial\n\nsecurity:\n  level: notareal"

  let assert Error(_) = parser.parse(input)
}
