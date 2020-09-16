;;; un-mini.el --- Automatically close minibuffer after it loses focus  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Shen, Jen-Chieh
;; Created date 2020-09-16 15:17:15

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Description: Automatically close minibuffer after if loses focus.
;; Keyword: minibuffer
;; Version: 0.1.0
;; Package-Requires: ((emacs "25.1"))
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

;;; Entry

(defun un-mini--enable ()
  "Enable `un-mini'."
  (add-hook 'minibuffer-setup-hook #'un-mini--minibuffer-setup)
  (add-hook 'minibuffer-exit-hook #'un-mini--minibuffer-exit))

(defun un-mini--disable ()
  "Disable `un-mini'."
  (remove-hook 'minibuffer-setup-hook #'un-mini--minibuffer-setup)
  (remove-hook 'minibuffer-exit-hook #'un-mini--minibuffer-exit))

;;;###autoload
(define-minor-mode un-mini-mode
  "Toggle un-mini mode on or off."
  :group 'un-mini
  :global t
  :lighter " UN-MINI"
  (if un-mini-mode (un-mini--enable) (un-mini--disable)))

;;; Core

(defun un-mini--in-minibuffer-window-p ()
  "Return non-nil if current window is minibuffer window."
  (eq (selected-window) (minibuffer-window)))

(defun un-mini--minibuffer-setup ()
  "Call when minibuffer setup."
  (add-hook 'post-command-hook #'un-mini--post-command))

(defun un-mini--minibuffer-exit ()
  "Call when minibuffer exit."
  (remove-hook 'post-command-hook #'un-mini--post-command))

(defun un-mini--post-command ()
  "Global post command during minibuffer activation."
  (unless (un-mini--in-minibuffer-window-p)
    (top-level)))

(provide 'un-mini)
;;; un-mini.el ends here
