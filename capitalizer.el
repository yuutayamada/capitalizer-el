;;; capitalizer.el --- capitalize previous word if necessarily

;; Copyright (C) 2014 by Yuta Yamada

;; Author: Yuta Yamada <cokesboy"at"gmail.com>
;; URL: https://github.com/yuutayamada/capitalizer-el
;; Version: 0.0.1
;; Package-Requires: ((package "version-number"))
;; Keywords: keyword

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
(require 'cl-lib)
(autoload 'capitalizer-sql "capitalizer-sql")
(autoload 'capitalizer-go "capitalizer-go")
(autoload 'capitalizer-scala "capitalizer-scala")
(autoload 'word-at-point "thingatpt")

(require 's)

(defvar capitalizer-prog-mode-flag nil
  "Non-nil means this buffer is related programing mode.
Otherwise nil.")

(add-hook 'prog-mode-hook
          (lambda ()
            (set (make-local-variable 'capitalizer-prog-mode-flag) t)))

(easy-mmode-define-minor-mode
 capitalizer-mode "Capitalize mode related things" nil " ©" nil
 (if capitalizer-mode
     (add-hook 'post-self-insert-hook 'capitalizer-capitalize)
   (remove-hook 'post-self-insert-hook 'capitalizer-capitalize)))

(defun capitalizer-capitalize ()
  ""
  (interactive)
  (when (and capitalizer-mode
             (not (capitalizer-comment-or-string-p (1- (point)))))
    (cl-case major-mode
      (go-mode    (capitalizer-go))
      (sql-mode   (capitalizer-sql))
      (scala-mode (capitalizer-scala)))))

(defun capitalizer-get-previous-word (&optional end-of-sentence num)
  ""
  (interactive)
  (let ((sentence-end (or end-of-sentence sentence-end)))
    (save-excursion
      (backward-char (or num 1))
      (thing-at-point (if end-of-sentence 'sentence 'word)))))

(defun capitalizer-comment-or-string-p (&optional point)
  "Return non-nil if current POINT is comment or string face."
  (save-excursion (nth 8 (syntax-ppss (max 0 (or point (point)))))))

(provide 'capitalizer)

;; Local Variables:
;; coding: utf-8
;; mode: emacs-lisp
;; End:

;;; capitalizer.el ends here
