K9!
# SPDX-License-Identifier: MPL-2.0
# Example Hunt-level K9 component: Repository setup automation
# Security Level: Hunt (full execution with Just recipes)
# Signature required before execution

{
  pedigree = {
    schema_version = "1.0.0",
    component_type = "repository-setup",
    security = {
      leash = 'Hunt,
      trust_level = "full-system-access",
      allow_network = true,
      allow_filesystem_write = true,
      allow_subprocess = true,
      signature_required = true,
    },
    metadata = {
      name = "setup-repo",
      version = "1.0.0",
      description = "Automated repository setup with K9 ecosystem defaults",
      author = "Hyperpolymath Coordination <coordination@hyperpolymath.dev>",
    },
    warnings = [
      "This component has full system access",
      "Only run from trusted sources with verified signatures",
      "Review Just recipes before execution",
      "Use dry-run mode first: ./must --dry-run run setup-repo.k9.ncl",
    ],
  },

  config = {
    repo_name
      | String
      | std.string.NonEmpty
      = "k9-member-repo",

    repo_type
      | [| 'Library, 'Application, 'Tool, 'Specification |]
      = 'Tool,

    primary_language
      | String
      | std.string.NonEmpty
      = "rust",

    features = {
      checkpoint_files | Bool = true,
      security_workflows | Bool = true,
      quality_checks | Bool = true,
      mirroring | Bool = false,
    },

    git = {
      default_branch = "main",
      initial_commit | Bool = true,
      remote_url | String = "https://github.com/hyperpolymath/k9-member-repo.git",
    },
  },

  recipes = {
    default = {
      recipe = "setup",
      description = "Set up K9 member repository",
    },

    setup = {
      dependencies = ["check-env", "create-structure", "init-git", "setup-workflows"],
      commands = [
        "echo 'Repository setup complete'",
        "echo 'Run: git status to see changes'",
      ],
    },

    "check-env" = {
      description = "Verify required tools are installed",
      commands = [
        "command -v git || (echo 'ERROR: git not found' && exit 1)",
        "command -v just || (echo 'ERROR: just not found' && exit 1)",
        "command -v nickel || (echo 'ERROR: nickel not found' && exit 1)",
        "echo 'All required tools present'",
      ],
    },

    "create-structure" = {
      description = "Create K9 repository structure",
      commands = [
        "mkdir -p src/ docs/ tests/ scripts/",
        "mkdir -p .github/workflows/",
        "mkdir -p .machine_readable/contractiles/k9/",
        "echo 'Directory structure created'",
      ],
    },

    "init-git" = {
      description = "Initialize Git repository",
      commands = [
        "git init -b %{config.git.default_branch}",
        "git config user.name 'Hyperpolymath Coordination'",
        "git config user.email 'coordination@hyperpolymath.dev'",
        "echo 'Git initialized'",
      ],
    },

    "setup-workflows" = {
      description = "Add K9 validation workflows",
      commands = [
        "echo 'Workflows configured'",
      ],
    },

    "create-checkpoint-files" = {
      description = "Create STATE.a2ml, ECOSYSTEM.a2ml, META.a2ml",
      commands = [
        "echo '(state (version \"1.0.0\") (project \"%{config.repo_name}\"))' > STATE.a2ml",
        "echo '(ecosystem (version \"1.0.0\") (name \"%{config.repo_name}\"))' > ECOSYSTEM.a2ml",
        "echo '(meta (version \"1.0.0\") (project \"%{config.repo_name}\"))' > META.a2ml",
        "echo 'Checkpoint files created'",
      ],
    },
  },

  validation = {
    check_repo_name = std.string.length config.repo_name > 0,
    check_language = std.string.length config.primary_language > 0,
  },
}
