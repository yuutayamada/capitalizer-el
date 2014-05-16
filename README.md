# capitalizer.el

This package still work in progress.
This package can capitalize specific word automatically.

## USAGE

Set following configuration to your .emacs.

```lisp
(autoload 'capitalizer-mode "capitalizer")
(add-hook 'after-change-major-mode-hook 'capitalizer-mode)
```

## REQUIREMENT

You need install `auto-capitalize.el`
