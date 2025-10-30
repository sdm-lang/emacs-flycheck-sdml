;;; flycheck-sdml.el --- Use Flycheck to run sdml-lint -*- lexical-binding: t; -*-

;; Author: Simon Johnston <johnstonskj@gmail.com>
;; Version: 0.1.5
;; Package-Requires: ((emacs "28.2") (flycheck "32") (dash "2.9.1") (sdml-mode "0.1.8"))
;; URL: https://github.com/johnstonskj/emacs-sdml-mode
;; Keywords: languages tools

;;; License:

;; Copyright (c) 2023, 2024 Simon Johnston
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;; Copyright 2023-2025 Simon Johnston <johnstonskj@gmail.com>
;; 
;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the “Software”), to deal
;; in the Software without restriction, including without limitation the rights to
;; use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
;; the Software, and to permit persons to whom the Software is furnished to do so,
;; subject to the following conditions:
;; 
;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
;; INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
;; PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
;; SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;;; Commentary:

;; This package provides a Flycheck backend for SDML
;; (Simple Domain Modeling Language) buffers.

;; Install
;;
;; Install is easiest from MELPA, here's how with `use-package`. Note the hook
;; clause to ensure this minor mode is always enabled for SDML source files.
;;
;; `(use-package flycheck-sdml
;;   :after (flycheck sdml-mode)
;;   :hook (sdml-mode . flycheck-mode)'
;;
;; Or, interactively; `M-x package-install RET sdml-ispell RET'
;;

;;; Code:

(require 'flycheck)
(require 'dash)
(require 'sdml-mode)

;; --------------------------------------------------------------------------
;; Customization
;; --------------------------------------------------------------------------

(defcustom flycheck-sdml-reporting-level 'help
  "The level of things reported."
  :tag "Flycheck message filter level"
  :type '(choice (const :tag "Warnings" warnings)
                 (const :tag "Notes" notes)
                 (const :tag "Help" help))
  :group 'sdml)

;; --------------------------------------------------------------------------
;; Actual checker
;; --------------------------------------------------------------------------

(defun flycheck-sdml--make-error (linter-line checker)
  "Turn LINTER-LINE into a `flycheck-error' as CHECKER."
  (let* ((parts (split-string linter-line ","))
         (level (let ((level (intern-soft (nth 0 parts))))
                  (cond
                   ((eq level 'bug) 'error)
                   ((eq level 'note) 'info)
                   ((eq level 'help) 'info)
                   (t level))))
         (line (string-to-number (nth 2 parts)))
         (column (string-to-number (nth 3 parts)))
         (end-line (string-to-number (nth 4 parts)))
         (end-column (string-to-number (nth 5 parts)))
         (id (nth 6 parts))
         (message (string-join (nthcdr 7 parts) " ")))
    (flycheck-error-new-at
     line
     column
     level
     message
     :end-line end-line
     :end-column end-column
     :checker checker
     :id id)))

(defun flycheck-sdml--start (checker callback)
  "Flycheck start function for sdml.

CHECKER is this checker, and CALLBACK is the flycheck dispatch function."
  (message "Running flycheck checker %s" checker)
  (let* ((command-line
          (format "%s --no-color validate --short-form --level %s --input %s"
                  (executable-find (or sdml-mode-cli-name "sdml"))
                  flycheck-sdml-reporting-level
                  (buffer-file-name)))
         (command-output (shell-command-to-string command-line))
         (output-lines (-filter (lambda (s) (not (string-empty-p s)))
                                (split-string command-output "\n")))
         (results (-map (lambda (s) (flycheck-sdml--make-error s checker))
                        output-lines)))
    (funcall callback 'finished results)))

(flycheck-define-generic-checker 'sdml
  "Report issues in SDML using the command-line validation tool."
  :start #'flycheck-sdml--start
  :modes '(sdml-mode))

;; --------------------------------------------------------------------------
;; Flycheck Minor Mode
;; --------------------------------------------------------------------------

;;;###autoload
(define-minor-mode
  sdml-flycheck-mode
  "Minor mode to provide flycheck integration for SDML buffers."
  :group 'sdml
  :tag "SDML flycheck minor mode"
  :lighter nil
  ;; We should avoid raising any error in this function, as in combination
  ;; with `global-flycheck-mode' it will render Emacs unusable.
  (with-demoted-errors "Error in sdml-flycheck-mode: %S"
    (add-to-list 'flycheck-checkers 'sdml))

  (flycheck-mode))

(provide 'flycheck-sdml)

;;; flycheck-sdml.el ends here
