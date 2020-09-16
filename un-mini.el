;;; un-mini.el --- Automatically close minibuffer after it loses focus  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Shen, Jen-Chieh
;; Created date 2020-09-16 15:17:15

;; Author: Shen, Jen-Chieh <jcs090218@gmail.com>
;; Description: Automatically close minibuffer after if loses focus.
;; Keyword: minibuffer
;; Version: 0.2.1
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

(defcustom un-mini-mouse t
  "Close minibuffer when using mouse."
  :type 'boolean
  :group 'un-mini)

(defcustom un-mini-command t
  "Close minibuffer when using command."
  :type 'boolean
  :group 'un-mini)

(defcustom un-mini-abort-commands
  '(right-click-context-click-menu)
  "List of command that are not allow to be executed during minibuffer."
  :type 'list
  :group 'un-mini)

(defcustom un-mini-before-abort-hook nil
  "Hooks run before aborting minibuffer."
  :type 'hook
  :group 'un-mini)

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

(defun un-mini-quit-minibuffer ()
  "Quit minibuffer."
  (run-hooks 'mini-before-abort-hook)
  ;; TODO: `top-level' is noisy, change to another function that are much quite
  ;; and also resolve recursive edit to minibuffer.
  ;;
  ;; Another issue is when user selecting another window, the newly selected
  ;; window cannot be preserved.
  (top-level))

(defun un-mini--in-minibuffer-window-p ()
  "Return non-nil if current window is minibuffer window."
  (eq (selected-window) (minibuffer-window)))

(defun un-mini--minibuffer-setup ()
  "Call when minibuffer setup."
  (add-hook 'pre-command-hook #'un-mini--pre-command)
  (add-hook 'post-command-hook #'un-mini--post-command))

(defun un-mini--minibuffer-exit ()
  "Call when minibuffer exit."
  (remove-hook 'pre-command-hook #'un-mini--pre-command)
  (remove-hook 'post-command-hook #'un-mini--post-command))

(defun un-mini--close-p ()
  "Return non-nil if valid to close minibuffer."
  (let ((cmd (if this-command (symbol-name this-command) "")))
    (cond ((and (not un-mini-mouse) (not un-mini-command)) nil)
          ((and un-mini-mouse (string-match-p "mouse-" cmd)) t)
          (un-mini-command t))))

(defun un-mini--pre-command ()
  "Global pre command during minibuffer activation."
  (when (memq this-command un-mini-abort-commands)
    (un-mini-quit-minibuffer)))

(defun un-mini--post-command ()
  "Global post command during minibuffer activation."
  (when (and (not (un-mini--in-minibuffer-window-p))
             (un-mini--close-p))
    (un-mini-quit-minibuffer)))

(provide 'un-mini)
;;; un-mini.el ends here
