// SPDX-License-Identifier: MPL-2.0
// (MPL-2.0 preferred; MPL-2.0 required for Hex.pm)
//
// k9_gleam_bench_test — Timing/benchmark tests for K9 parser/renderer.
//
// Uses repetition-based guards to detect gross performance regressions.
// Gleam does not have a built-in benchmarking harness, so these tests
// verify that bulk operations complete without error rather than asserting
// wall-clock bounds (which would be flaky in CI).

import gleam/list
import k9_gleam/parser
import k9_gleam/renderer
import k9_gleam/types.{Kennel, Yard}

// ---------------------------------------------------------------------------
// Benchmark: parse 500 minimal components without error
// ---------------------------------------------------------------------------

pub fn bench_parse_500_minimal_test() {
  let input =
    "pedigree:\n  name: bench-parse\n  version: 1.0.0\n  description: Bench\n\nsecurity:\n  level: kennel"

  list.range(from: 1, to: 500)
  |> list.each(fn(_) {
    let assert Ok(_) = parser.parse(input)
  })
}

// ---------------------------------------------------------------------------
// Benchmark: render 500 components without error
// ---------------------------------------------------------------------------

pub fn bench_render_500_test() {
  let input =
    "pedigree:\n  name: bench-render\n  version: 1.0.0\n  description: Bench\n\nsecurity:\n  level: yard\n  allow-network: true\n  allow-fs-write: false\n  allow-subprocess: false"

  let assert Ok(component) = parser.parse(input)

  list.range(from: 1, to: 500)
  |> list.each(fn(_) {
    let out = renderer.render(component)
    assert out != ""
  })
}

// ---------------------------------------------------------------------------
// Benchmark: 200 full roundtrips without error
// ---------------------------------------------------------------------------

pub fn bench_200_roundtrips_test() {
  let input =
    "pedigree:\n  name: bench-rt\n  version: 2.0.0\n  description: Roundtrip bench\n  author: Jonathan D.A. Jewell\n  license: MPL-2.0\n\nsecurity:\n  level: hunt\n  allow-network: false\n  allow-fs-write: false\n  allow-subprocess: false\n\ntags: bench, roundtrip"

  list.range(from: 1, to: 200)
  |> list.each(fn(_) {
    let assert Ok(c1) = parser.parse(input)
    let rendered = renderer.render(c1)
    let assert Ok(_c2) = parser.parse(rendered)
  })
}

// ---------------------------------------------------------------------------
// Benchmark: parse_security_level 1000 times without error
// ---------------------------------------------------------------------------

pub fn bench_parse_security_level_1000_test() {
  let levels = ["kennel", "yard", "hunt", "KENNEL", "Yard", "HUNT"]
  let count = list.length(levels)

  list.range(from: 0, to: 999)
  |> list.each(fn(i) {
    let idx = i % count
    let level = case idx {
      0 -> "kennel"
      1 -> "yard"
      2 -> "hunt"
      3 -> "KENNEL"
      4 -> "Yard"
      _ -> "HUNT"
    }
    let _ = parser.parse_security_level(level)
    Nil
  })
}

// ---------------------------------------------------------------------------
// Benchmark: render_security_level 1000 times without error
// ---------------------------------------------------------------------------

pub fn bench_render_security_level_1000_test() {
  let levels = [Kennel, Yard, types.Hunt]
  let count = list.length(levels)

  list.range(from: 0, to: 999)
  |> list.each(fn(i) {
    let level = case i % count {
      0 -> Kennel
      1 -> Yard
      _ -> types.Hunt
    }
    let _ = renderer.render_security_level(level)
    Nil
  })
}
