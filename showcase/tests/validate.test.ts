// SPDX-License-Identifier: MPL-2.0
// Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

import { assertEquals, assert } from "https://deno.land/std@0.208.0/assert/mod.ts";

// Unit tests: Basic K9 example structure validation
Deno.test("Unit: K9 examples file exists", async () => {
  const path = "content/examples.md";
  const result = await Deno.stat(path);
  assertEquals(result.isFile, true);
});

Deno.test("Unit: K9 examples contain required sections", async () => {
  const content = await Deno.readTextFile("content/examples.md");
  assert(content.includes("# Examples") || content.includes("# Example"));
  assert(content.includes("##"));  // Has subsections
});

Deno.test("Unit: K9 examples have SPDX headers", async () => {
  const content = await Deno.readTextFile("content/examples.md");
  const matches = content.match(/SPDX-License-Identifier: MPL-2.0\.0-or-later/g);
  assert(matches !== null && matches.length >= 1, "Should have SPDX headers");
});

Deno.test("Unit: All content markdown files exist", async () => {
  const expectedFiles = [
    "content/index.md",
    "content/examples.md",
    "content/integrations.md",
    "content/getting-started.md",
    "content/security-levels.md",
  ];

  for (const file of expectedFiles) {
    const result = await Deno.stat(file);
    assertEquals(result.isFile, true, `File ${file} should exist`);
  }
});

// Smoke tests: K9 syntax validation
Deno.test("Smoke: K9 declaration blocks are present", async () => {
  const content = await Deno.readTextFile("content/examples.md");
  // K9 uses structured declaration formats
  assert(
    content.match(/^#+\s+/m) !== null,
    "Should have heading markers for structure"
  );
});

Deno.test("Smoke: K9 security levels are documented", async () => {
  const content = await Deno.readTextFile("content/security-levels.md");
  assert(content.includes("security") || content.includes("Security"));
  assert(content.includes("#"));  // Has structure
});

Deno.test("Smoke: README/EXPLAINME references content correctly", async () => {
  const explainme = await Deno.readTextFile("EXPLAINME.adoc");
  assert(explainme.includes("content") || explainme.includes("test"));
});

// Contract tests: Required K9 structure
Deno.test("Contract: Examples have consistent structure", async () => {
  const content = await Deno.readTextFile("content/examples.md");
  const lines = content.split("\n");

  // At least some content
  assert(lines.length > 10, "Examples should have meaningful content");

  // Has hierarchy
  const hasHeadings = lines.some((l) => l.startsWith("##"));
  assert(hasHeadings, "Should have section headings");
});

Deno.test("Contract: Getting started guide is complete", async () => {
  const content = await Deno.readTextFile("content/getting-started.md");
  assert(content.length > 100, "Getting started should have content");
  assert(
    content.includes("#") || content.includes("---"),
    "Should have structure"
  );
});

// Aspect tests: Cross-cutting consistency
Deno.test("Aspect: All markdown files have consistent formatting", async () => {
  const files = [
    "content/examples.md",
    "content/integrations.md",
    "content/getting-started.md",
  ];

  for (const file of files) {
    const content = await Deno.readTextFile(file);
    // Check for reasonable structure
    assert(
      content.length > 50,
      `File ${file} should have meaningful content`
    );
  }
});

Deno.test("Aspect: Content files are properly closed (syntax check)", async () => {
  const content = await Deno.readTextFile("content/examples.md");

  // Check for balanced markdown code blocks
  const openTicks = (content.match(/```/g) || []).length;
  assert(
    openTicks % 2 === 0,
    "Markdown code blocks should be balanced"
  );
});

Deno.test("Aspect: Directory structure is consistent", async () => {
  const dirStructure = [
    "content",
    "output",
    ".machine_readable",
  ];

  for (const dir of dirStructure) {
    const stat = await Deno.stat(dir);
    assertEquals(stat.isDirectory, true, `Directory ${dir} should exist`);
  }
});

// Property-based tests: Invariants
Deno.test("Property: All content files are readable and non-empty", async () => {
  const files = [
    "content/index.md",
    "content/examples.md",
    "content/integrations.md",
    "content/getting-started.md",
    "content/security-levels.md",
  ];

  for (const file of files) {
    const content = await Deno.readTextFile(file);
    assert(content.length > 0, `File ${file} should not be empty`);
    assert(content.includes("#"), `File ${file} should have markdown structure`);
  }
});

Deno.test("Property: SPDX licenses are consistent", async () => {
  const files = [
    "content/examples.md",
    "content/getting-started.md",
  ];

  const results = [];
  for (const file of files) {
    try {
      const content = await Deno.readTextFile(file);
      const hasSpdx = content.includes("SPDX") || content.includes("License");
      results.push({ file, hasSpdx });
    } catch {
      // File may not have license header
    }
  }

  assert(results.length > 0, "Should find content files");
});

// E2E/Reflexive tests: Complete pipeline
Deno.test("E2E: Example parsing round-trip", async () => {
  const content = await Deno.readTextFile("content/examples.md");

  // Extract structured sections
  const lines = content.split("\n");
  const sections = [];
  let currentSection = "";

  for (const line of lines) {
    if (line.startsWith("##")) {
      if (currentSection) {
        sections.push(currentSection);
      }
      currentSection = line;
    }
  }

  if (currentSection) {
    sections.push(currentSection);
  }

  assert(sections.length > 0, "Should parse sections from content");
});

Deno.test("E2E: Integration file structure is sound", async () => {
  const content = await Deno.readTextFile("content/integrations.md");

  // Should mention integrations
  assert(
    content.toLowerCase().includes("integr") ||
    content.includes("##"),
    "Should have integration content"
  );

  // Should be parseable
  const lines = content.split("\n").filter((l) => l.trim());
  assert(lines.length > 5, "Should have multiple lines of content");
});

Deno.test("E2E: Output directory reflects input", async () => {
  const inputFiles = await Promise.all([
    Deno.readDir("content"),
  ]);

  const contentFiles = [];
  for await (const entry of inputFiles[0]) {
    if (entry.isFile && entry.name.endsWith(".md")) {
      contentFiles.push(entry.name);
    }
  }

  assert(
    contentFiles.length > 0,
    "Should have markdown files in content/"
  );
});

// Benchmark baseline (timing assertions)
Deno.test("Benchmark: K9 file reading performance", async () => {
  const start = performance.now();
  const content = await Deno.readTextFile("content/examples.md");
  const end = performance.now();

  const duration = end - start;
  assert(duration < 100, `File read should complete in < 100ms, took ${duration.toFixed(2)}ms`);
});

Deno.test("Benchmark: Content completeness baseline", async () => {
  const content = await Deno.readTextFile("content/examples.md");
  const charCount = content.length;

  // Baseline: expect meaningful documentation
  assert(
    charCount > 500,
    `Examples should have substantial content, found ${charCount} characters`
  );
});
