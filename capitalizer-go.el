;;; capitalizer-go.el --- capitalizer for golang

;; Copyright (C) 2014 by Yuta Yamada

;; Author: Yuta Yamada <cokesboy"at"gmail.com>

;;; License:
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;; Commentary:

;;; Code:
(eval-when-compile (require 'cl))
(require 'capitalizer)
(require 'go-mode)

(defvar capitalizer-go-packages (go-packages))

(defun capitalizer-go-package-p ()
  "Return non-nil, if pre word is package."
  (interactive)
  (loop with pre-word = (capitalizer-get-previous-word nil 2)
        for pkg in capitalizer-go-packages
        for subpkg = (when pkg (nth 1 (split-string pkg "/")))
        if (and (stringp pkg)
                (or (string-match (format "^%s$" pkg)    pre-word)
                    (string-match (format "^%s$" subpkg) pre-word)))
        do (return (or subpkg pkg))))

(defun capitalizer-go ()
  "Capitalize function for golang."
  (if (equal 46 (char-before (1- (point)))) ; 46 means "."
      (when (capitalizer-go-package-p)
        (capitalize-word -1))))

(defadvice gofmt-before-save
  (around capitalizer-save-go-package activate)
  "Update `capitalizer-go-packages' when gofmt."
  ad-do-it
  (setq capitalizer-go-packages (go-packages)))

(provide 'capitalizer-go)

;; Local Variables:
;; coding: utf-8
;; mode: emacs-lisp
;; End:

;;; capitalizer-go.el ends here
