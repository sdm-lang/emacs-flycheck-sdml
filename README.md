# SDML Mode for Emacs

![SDML Logo Text](https://raw.githubusercontent.com/sdm-lang/.github/main/profile/horizontal-text.svg)

This package provides a [`flycheck`](https://github.com/flycheck/flycheck) back-end for SDML ([Simple Domain Modeling
Language](https://github.com/johnstonskj/tree-sitter-sdml)) buffers.

The implementation uses the SDML command-line tool to perform the validation
checks.

## Installing

Install is easiest from MELPA, here's how with `use-package`. Note the hook clause
to ensure this minor mode is always enabled for SDML source files.

```elisp
(use-package flycheck-sdml
  :after (flycheck sdml-mode)
  :hook (sdml-mode . flycheck-mode)
```

Or, interactively; `M-x package-install RET sdml-ispell RET`

## Contributing

This package includes an [Eldev](https://github.com/emacs-eldev/eldev) file and the following MUST be run before
creating any PR.

- `eldev lint`
- `eldev doctor`
- `eldev package --load-before-compiling --stop-on-failure --warnings-as-errors`
- `eldev test`
- `eldev test --undercover auto,coveralls,merge,dontsent -U simplecov.json`
- `eldev release -nU 9.9.9`

The script [eldev-check.sh](https://gist.github.com/johnstonskj/6af5ef6866bfb1288f4962a6ba3ef418) may be useful to you if you do not have your own Eldev workflow.

## License

This package is released under the Apache License, Version 2.0. See the LICENSE
file in this repository for details.

## Changes

The `0.1.x` series are all pre-release and do not appear in ELPA/MELPA.
