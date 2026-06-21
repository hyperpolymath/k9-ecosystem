K9!
# SPDX-License-Identifier: MPL-2.0
# Example Kennel-level K9 component: Project metadata
# Security Level: Kennel (pure data, no execution)
# No signature required

{
  pedigree = {
    schema_version = "1.0.0",
    component_type = "project-metadata",
    security = {
      leash = 'Kennel,
      trust_level = "data-only",
      allow_network = false,
      allow_filesystem_write = false,
      allow_subprocess = false,
    },
    metadata = {
      name = "project-metadata",
      version = "1.0.0",
      description = "Pure data configuration for project metadata",
      author = "Hyperpolymath Coordination <coordination@hyperpolymath.dev>",
    },
  },

  project = {
    name = "k9-ecosystem",
    version = "0.1.0",
    description = "K9 ecosystem coordination hub",

    repository = {
      url = "https://github.com/hyperpolymath/k9-ecosystem",
      type = "git",
    },

    author = {
      name = "Hyperpolymath Coordination",
      email = "coordination@hyperpolymath.dev",
      organization = "hyperpolymath",
    },

    license = "MPL-2.0",

    keywords = [
      "k9",
      "nickel",
      "contractiles",
    ],
  },

  export = {
    format = "json",
    destination = "project-metadata.json",
  },
}
