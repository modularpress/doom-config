;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; config.el
(setq doom-font (font-spec :family "Menlo" :size 18)
      doom-variable-pitch-font (font-spec :family "Georgia" :size 18))

;; Make j/k move by logical lines even with visual-line-mode active
(setq evil-respect-visual-line-mode nil)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this on
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; Basic org setup
(setq org-directory "~/org/")
(setq org-agenda-files '("~/org/tasks.org"
                         "~/org/research/"
                         "~/org/writing/"
                         "~/org/courses/"))

;; Capture templates: quickly add notes and tasks
(setq org-capture-templates
     '(("t" "Todo" entry (file+headline "~/org/tasks.org" "Inbox")
         "* TODO %?\n  %U\n  %a")
        ("n" "Note" entry (file+datetree "~/org/notes.org")
         "* %?\nEntered on %U\n  %i\n  %a")))

;; Save Org files automatically
(after! org
  (add-hook 'org-mode-hook #'auto-save-visited-mode))

;; Olivetti settings
(after! olivetti
  (setq olivetti-body-width 100
        olivetti-minimum-body-width 80))

;; Markdown hooks
(add-hook 'markdown-mode-hook
          (lambda ()
            ;; Center text and disable auto-fill
            (olivetti-mode 1)
            (auto-fill-mode -1)
            ;; Enable spell-fu
            (spell-fu-mode 1)
            ;; Electric indentation
            (electric-indent-local-mode 1)))

;; Fix visual mode indentation
(map! :v "SPC >" #'indent-rigidly-right
      :v "SPC <" #'indent-rigidly-left)

;; Markdown list continuation and RET handling
(after! markdown-mode
  (setq markdown-indent-on-enter 'indent-and-new-item  ; Restore auto-continuation
        markdown-list-item-bullets '("-" "+" "*")))

;; Spell checking backend: use Hunspell, English only
(after! ispell
  (setq ispell-program-name "hunspell"
        ispell-dictionary "en_US"))

;; All markdown formatting marks in red
(after! markdown-mode
  ;; Ensure markup is visible
  (setq markdown-hide-markup nil)

  ;; Set ALL markdown markup faces to red
  (custom-set-faces!
    '(markdown-markup-face :foreground "red" :weight bold)
    '(markdown-header-delimiter-face :foreground "red" :weight bold)
    '(markdown-list-face :foreground "red" :weight bold)
    '(markdown-bold-face :foreground "red" :weight bold)
    '(markdown-italic-face :foreground "red" :slant italic)
    '(markdown-code-face :foreground "red")
    '(markdown-inline-code-face :foreground "red")
    '(markdown-link-face :foreground "red")
    '(markdown-url-face :foreground "red")
    '(markdown-reference-face :foreground "red")
    '(markdown-blockquote-face :foreground "red"))

  ;; Add comprehensive font-lock rules for all markdown formatting
  (font-lock-add-keywords 'markdown-mode
    '(;; Headers: # ## ### etc.
      ("^\\(#+\\)" 1 '(:foreground "red" :weight bold))
      ;; Lists: - * +
      ("^[ \t]*\\([-*+]\\)" 1 '(:foreground "red" :weight bold))
      ;; Bold: **text** or __text__
      ("\\(\\*\\*\\)\\([^*]+\\)\\(\\*\\*\\)" (1 '(:foreground "red" :weight bold)) (3 '(:foreground "red" :weight bold)))
      ("\\(__\\)\\([^_]+\\)\\(__\\)" (1 '(:foreground "red" :weight bold)) (3 '(:foreground "red" :weight bold)))
      ;; Italic: *text* or _text_
      ("\\(?:^\\|[^*]\\)\\(\\*\\)\\([^*\n]+\\)\\(\\*\\)\\(?:[^*]\\|$\\)" (1 '(:foreground "red")) (3 '(:foreground "red")))
      ("\\(?:^\\|[^_]\\)\\(_\\)\\([^_\n]+\\)\\(_\\)\\(?:[^_]\\|$\\)" (1 '(:foreground "red")) (3 '(:foreground "red")))
      ;; Inline code: `code`
      ("\\(`\\)[^`\n]*\\(`\\)" (1 '(:foreground "red")) (2 '(:foreground "red")))
      ;; Links: [text](url)
      ("\\(\\[\\)[^]]*\\(\\]\\)(\\([^)]*\\))" (1 '(:foreground "red")) (2 '(:foreground "red")))
      ;; Blockquotes: >
      ("^[ \t]*\\(>+\\)" 1 '(:foreground "red"))
      ;; Horizontal rules: --- or ***
      ("^[ \t]*\\(---+\\|\\*\\*\\*+\\|___+\\)[ \t]*$" 1 '(:foreground "red" :weight bold))
      ;; Checkboxes: - [ ] or - [x]
      ("^[ \t]*[-*+][ \t]+\\(\\[[ xX]\\]\\)" 1 '(:foreground "red")))))

;; Hook to apply the formatting when entering markdown mode
(add-hook 'markdown-mode-hook
          (lambda ()
            (font-lock-mode -1)
            (font-lock-mode 1)))
