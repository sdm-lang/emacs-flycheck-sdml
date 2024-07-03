# SDML Mode for Emacs

![SDML Logo Text](https://raw.githubusercontent.com/sdm-lang/.github/main/profile/horizontal-text.svg)

This package provides an Emacs tree-sitter based minor mode for SDML - the
[Simple Domain Modeling Language](https://github.com/johnstonskj/tree-sitter-sdml). This mode provides a [`flycheck`](https://github.com/flycheck/flycheck) back-end that runs
lint rules on open buffers.

The current implementation uses tree-sitter queries directly and a set of rules
in the custom variable `sdml-lint-rules`. Future versions may provide the option
to use the SDML command-line tool for validation instead.

## Installing

Currently the package is not published and so installation has to be done
manually. You will also need to install the base `sdml-mode` first.

### Install manually

First clone the Git repository to a local path.

```bash
    git clone https://github.com/johnstonskj/emacs-flycheck-sdml.git
```

The following uses `use-package` but any equivalent package manager should work.

```elisp
(use-package flycheck-sdml
  :after (flycheck sdml-mode)
  :load-path "/path/to/repo")
```

## Usage

To enable, simply ensure Flycheck mode is enabled for your buffer. Rather than
per-buffer, you can enable this by setting `flycheck-mode` for all SDML files with
a hook, or you can use a global flycheck mode.

```elisp
(use-package flycheck-sdml
  :after (flycheck sdml-mode)
  :load-path "/path/to/repo"
  :hook (sdml-mode . flycheck-mode)
```

The entire set of lint rules are stored in the custom variable `sdml-lint-rules`.

## Contributing

The packages in this repository should pass the standard package checks, including:

* `byte-compile-file`
* `package-lint`
* `checkdoc`

## License

This package is released under the Apache License, Version 2.0. See the LICENSE
file in this repository for details.

## Changes

The `0.1.x` series are all pre-release and do not appear in ELPA/MELPA.
