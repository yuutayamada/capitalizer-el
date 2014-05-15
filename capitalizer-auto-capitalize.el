;;; capitalizer-auto-capitalize.el --- configuration file for auto-capitalize.el

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
(require 'auto-capitalize)
(require 'capitalizer)
(eval-when-compile (require 'cl))
(autoload 'org-table-p "org")

(defvar capitalizer-auto-capitalize-before-point 0)

(defun capitalizer-switch-auto-capitalize-mode ()
  ""
  (when (and (not (minibufferp))
             (not (and auto-capitalize
                       (eq (max 0 (1- (point)))
                           capitalizer-auto-capitalize-before-point))))
    (if (or (and capitalizer-prog-mode-flag
                 (capitalizer-comment-or-string-p (1- (point))))
            (and (not capitalizer-prog-mode-flag)
                 (case major-mode
                   (org-mode (not (org-table-p)))
                   (t t))))
        (turn-on-auto-capitalize-mode)
      (turn-off-auto-capitalize-mode))))

(defadvice self-insert-command
  (around ad-turn-on-auto-capitalize activate)
  ""
  (capitalizer-switch-auto-capitalize-mode)
  ad-do-it
  (when auto-capitalize
    (setq-local capitalizer-auto-capitalize-before-point (point))))

(provide 'capitalizer-auto-capitalize)

;; Local Variables:
;; coding: utf-8
;; mode: emacs-lisp
;; End:

;;; capitalizer-auto-capitalize.el ends here
