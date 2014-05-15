;;; capitalizer-sql.el --- Capitalize SQL keywords

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
;; this package still work in progress
;;; Code:
(require 'capitalizer)
(eval-when-compile (require 'cl))

(defvar capitalizer-sql-keywords
  '("asc" "as" "update" "insert" "delete" "union" "all" "any" "some"
    "intersect" "except"
    "from" "with" "check" "option"
    "where" "into" "group" "having" "order" "by" "set"
    "create" "temporary" "table" "view"
    "drop" "truncate" "is" "null"
    "values" "database" "use" "desc" "describe" "not" "and" "or" "like"
    "exists" "between" "on" "in" "show" "column" "columns" "index" "warnings"
    "primary" "foreign" "key" "auto_increment"
    "alter" "add" "first" "after" "rename" "to"
    "change" "limit" "constraint" "references"
    "select" "distinct"
    "case" "when" "then" "else" "end"
    "natural" "inner" "cross" "join"
    "left" "right" "outer"
    "engine"
    "password" "for" "user" "identified" "grant"
    "revoke" "remove" "cascade" "restrict" "admin"
    "current_user" "current_date" "current_time"
    "transaction" "start" "commit" "rollback"))

(defvar capitalizer-sql-type-keywords
  '("varchar" "char" "character" "dec" "decimal" "blob" "time" "date"
    "int" "integer")) ;; some database has datetime or timestamp

(defvar capitalizer-sql-func-keywords
  '("abs" "avg" "acos" "asin" "atan" "cast" "ceil" "cos" "cot" "char_length"
    "count" "concat" "date_format" "exp" "floor"
    "format" "left" "ln" "log" "max" "min" "mod" "password" "pi" "power" "pow"
    "right" "radians" "rand" "round" "sum" "substring_index" "substr" "sign"
    "sin" "sqrt" "tan" "truncate" "index"))

(defvar capitalizer-sql-db-keywords '("InnoDB" "BDB"))

(defun capitalizer-sql-capitalize (word)
  "Capitalize previous WORD."
  (if (s-contains-p "_" word)
      (upcase-word -2)
    (upcase-word -1)))

(defun capitalizer-sql ()
  "Capitalize SQL word automatically."
  (interactive)
  (when (member last-input-event '(32 40 44 59)) ; " ", "(", ",", ";"
    (lexical-let ((word (capitalizer-get-previous-word "[ ,\n(	`]")))
      (when (capitalizer-sql-match-keyword-p word (s-right 1 word))
        (capitalizer-sql-capitalize word)))))

(defun capitalizer-sql-match-keyword-p (word suffix)
  "Return non-nil if WORD has SQL keyword.
The SUFFIX means WORD's suffix."
  (pcase suffix
    (`"(" (member (s-chop-suffix "(" word)
                  (append capitalizer-sql-type-keywords
                          capitalizer-sql-func-keywords)))
    (suffix (member (if (s-equals-p    suffix ",")
                        (s-chop-suffix suffix word)
                      word)
                    (append capitalizer-sql-keywords
                            capitalizer-sql-type-keywords)))))

(provide 'capitalizer-sql)

;; Local Variables:
;; coding: utf-8
;; mode: emacs-lisp
;; End:

;;; capitalizer-sql.el ends here
