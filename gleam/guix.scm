; SPDX-License-Identifier: MPL-2.0
;; guix.scm — GNU Guix package definition for k9_gleam
;; Usage: guix shell -f guix.scm

(use-modules (guix packages)
             (guix build-system gnu)
             (guix licenses))

(package
  (name "k9_gleam")
  (version "0.1.0")
  (source #f)
  (build-system gnu-build-system)
  (synopsis "k9_gleam")
  (description "k9_gleam — part of the hyperpolymath ecosystem.")
  (home-page "https://github.com/hyperpolymath/k9_gleam")
  (license ((@@ (guix licenses) license) "MPL-2.0"
             "https://github.com/hyperpolymath/palimpsest-license")))
