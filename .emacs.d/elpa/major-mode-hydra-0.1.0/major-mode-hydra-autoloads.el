;;; major-mode-hydra-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "major-mode-hydra" "major-mode-hydra.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from major-mode-hydra.el

(autoload 'major-mode-hydra-bind "major-mode-hydra" "\
Add BINDINGS (heads) for a MODE under the COLUMN.

MODE is the major mode name (symbol).  There is no need to quote it.

COLUMN is a string to put the hydra heads under.

BINDINGS is a list of hydra heads to be added.  Each head has
exactly the same structure as that in `pretty-hydra-define' or
`defhydra', except `:exit' is set to t by default.

\(fn MODE COLUMN &rest BINDINGS)" nil t)

(function-put 'major-mode-hydra-bind 'lisp-indent-function '2)

(autoload 'major-mode-hydra "major-mode-hydra" "\
Show the hydra for the current major mode.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "major-mode-hydra" '("major-mode-hydra-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; major-mode-hydra-autoloads.el ends here
