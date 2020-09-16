;;; un-mini.el --- Automatically close minibuffer after it loses focus  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Shen, Jen-Chieh
;; Created date 2020-09-16 15:17:15

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Description: Automatically close minibuffer after if loses focus.
;; Keyword: minibuffer
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.3"))
;; URL: https://github.com/jcs-elpa/un-mini

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Automatically close minibuffer after it loses focus.
;;

;;; Code:

(defgroup un-mini nil
  "Fill buffer so you don't see empty lines at the end."
  :prefix "un-mini-"
  :group 'tool
  :link '(url-link :tag "Repository" "https://github.com/jcs-elpa/un-mini"))

(define-minor-mode un-mini-mode
  "Toggle un-mini mode on or off."
  :group 'un-mini
  :global t
  :lighter " UN-MINI"
  (if un-mini-mode (progn) (progn)))

(provide 'un-mini)
;;; un-mini.el ends here
