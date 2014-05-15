;;; capitalizer-scala.el --- capitalizer for scala

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
;; work in progress
;;; Code:
(require 'scala-mode2 nil t)
(eval-when-compile (require 'cl))
(require 'thingatpt)

(defun capitalizer-scala ()
  (lexical-let*
      ((current-face (nth 1 (text-properties-at (1- (point)))))
       (type-face-p
        (lambda () (equal font-lock-type-face current-face)))
       (anonymous-func-type-p
        (lambda ()
          (and
           (string-match "^ ?+def " (thing-at-point 'line))
           (equal "=" (char-to-string (char-before (- (point) 3))))
           (equal ">" (char-to-string (char-before (- (point) 2)))))))
       (bracket-p
        (lambda ()
          (and (string-match "\\[" (char-to-string (char-before (1- (point)))))
               (string-match "]" (char-to-string (char-after (point))))))))
    (when (and (not (bobp))
               (not (equal font-lock-string-face current-face))
               (or (funcall type-face-p)
                   (and (not (equal font-lock-constant-face current-face))
                        (or (funcall anonymous-func-type-p)
                            (funcall bracket-p)))))
      (let ((case-fold-search nil))
        (unless  (string-match "[A-Z]" (word-at-point))
          (capitalize-word -1))))))

(provide 'capitalizer-scala)

;; Local Variables:
;; coding: utf-8
;; mode: emacs-lisp
;; End:

;;; capitalizer-scala.el ends here
