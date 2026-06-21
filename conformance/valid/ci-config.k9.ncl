K9!
# SPDX-License-Identifier: MPL-2.0
# Example Yard-level K9 component: CI/CD configuration with validation
# Security Level: Yard (Nickel evaluation, contract validation)
# Signature recommended but not required

{
  pedigree = {
    schema_version = "1.0.0",
    component_type = "ci-configuration",
    security = {
      leash = 'Yard,
      trust_level = "validated-config",
      allow_network = false,
      allow_filesystem_write = false,
      allow_subprocess = false,
    },
    metadata = {
      name = "ci-config",
      version = "1.0.0",
      description = "CI/CD configuration with runtime validation",
      author = "Hyperpolymath Coordination <coordination@hyperpolymath.dev>",
    },
  },

  ci = {
    platform
      | [| 'GitHubActions, 'GitLabCI, 'CircleCI, 'TravisCI |]
      = 'GitHubActions,

    matrix = {
      os
        | Array String
        | std.array.NonEmpty
        = ["ubuntu-latest", "macos-latest"],

      versions
        | Array String
        | std.array.NonEmpty
        = ["stable", "beta"],
    },

    steps = [
      {
        name = "Checkout",
        action = "actions/checkout@v4",
        sha | String | std.string.NonEmpty = "b4ffde65f46336ab88eb53be808477a3936bae11",
      },
      {
        name = "Build",
        run = "just build",
      },
      {
        name = "Test",
        run = "just test",
      },
      {
        name = "Lint",
        run = "just lint",
      },
    ],

    deploy = {
      enabled | Bool = false,

      branch
        | String
        | std.contract.from_predicate (fun b => b == "main" || b == "master")
        = "main",

      requires_approval | Bool = true,
    },

    security = {
      enabled | Bool = true,

      scanners = [
        {
          name = "CodeQL",
          languages = ["rust", "javascript"],
        },
        {
          name = "OSSF Scorecard",
          enabled = true,
        },
        {
          name = "TruffleHog",
          scan_for = "secrets",
        },
      ],
    },

    notifications = {
      on_success = "never",
      on_failure = "always",
      channels = ["email"],
    },
  },

  validation = {
    check_os = std.array.length ci.matrix.os > 0,
    check_versions = std.array.length ci.matrix.versions > 0,
    check_steps = std.array.length ci.steps >= 2,
    check_security = ci.security.enabled == true,
  },
}
