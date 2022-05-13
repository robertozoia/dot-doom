;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Roberto Zoia"
      user-mail-address "roberto@zoia.org")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;       ;; Fira Code
(setq doom-font (font-spec :family "SF Mono" :size 12 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "SF Pro" :weight 'light :size 14)
      doom-unicode-font (font-spec :family "SF Mono" :size 12)
      doom-big-font (font-spec :family "SF Mono" :size 18))

;; (setq fancy-splash-image (concat doom-private-dir "splash/" "doom-emacs-bw-dark.svg"))
(setq fancy-splash-image (concat doom-private-dir "splash/" "doom-emacs-color2.svg"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq doom-modeline-enable-word-count t)


;; dictionaries
(setq ispell-program-name "aspell")
(setenv "DICTIONARY" "english")
(setq ispell-dictionary "english")
(add-to-list
 'ispell-local-dictionary-alist
 '(("english" "[[:alpha::]]" "[^[:alpha]]" "[0-9']" t
    ("-d" "english") nil utf-8)))

(after! org
  ;; If you use `org' and don't want your org files in the default location below,
  ;; change `org-directory'. It must be set before org loads!
  (setq org-directory "~/org")
  (setq org-agenda-files '("~/org"))
  (setq org-default-notes-file (concat org-directory "/notes.org"))

  (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
  (setq org-mobile-inbox-for-pull "~/org/flagged.org")

  ;; (set-face-attribute 'org-headline-done nil :strike-through t)

  ;; org capture templates
  ;;
  ;; TODO make paths relative to org directories
  (setq org-capture-templates
        '(("b" "Blog idea" entry (file+headline "~/org/zoia-org.org" "Article ideas")
           "* %?\n")
          ("t" "Task"  entry (file org-default-notes-file)
           "* TODO %?" :empty-lines 1)
          ("q" "Quick note"  entry (file org-default-notes-file)
           "* %?\n" :empty-lines 1)
          ("1" "10 Business Ideas" entry (file+datetree "~/org/saas.org" "Business Ideas")
           "* %?")
          ("B" "Books worth considering" entry (file+headline "~/org/books.org" "Book recommendations")
           "* %?\n")
          ("C" "Contents to Current Clocked Task" plain
                   (clock)
                   "%i" :immediate-finish t :empty-lines 1))
        )


  (defun region-to-clocked-task (start end)
    "Copies the selected text to the currently clocked in org-mode task."
    (interactive "r")
    (org-capture-string (buffer-substring-no-properties start end) "C"))

 (global-set-key (kbd "C-<f9>") 'region-to-clocked-task )

;; org-journal
  (setq org-journal-dir "~/org/journal")
  (setq org-journal-file-type 'monthly)
  (setq org-journal-file-format "%Y-%m-%d.org")
  (setq org-journal-date-prefix "* ")
  (setq org-journal-date-format "%A, %Y-%m-%d")
  (setq org-journal-enable-agenda-integration t
        org-icalendar-store-UID t
        org-icalendar-include-todo "all"
        org-icalendar-combined-agenda-file "~/org/org-journal.ics")

  ;;(setq org-journal-created-property-timestamp-format "%Y-%m-%d")
  ;; org-roam
  (setq org-roam-directory (file-truename "~/org-roam"))
  (setq org-roam-index-file "Index.org")
  (setq org-roam-v2-ack t)

  ;; key bindings for org

  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c d")
                  (lambda () (interactive) (find-file "~/org/dashboard.org") ))

  ;; have a better-looking org-mode
  ;; Check here for inspiration/copy
  ;; https://zzamboni.org/post/beautifying-org-mode-in-emacs/
  ;;
  ;;Ask org-mode to hide the emphasis markup
  (setq org-hide-emphasis-markers t)

  (add-hook! org-mode :append #'org-appear-mode)
  (add-hook! org-mode :append #'mixed-pitch-mode)
  (add-hook! org-mode :append #'visual-line-mode)
  (add-hook! org-mode :append #'variable-pitch-mode)

  ;; screenshot capture
  ;; https://zzamboni.org/post/how-to-insert-screenshots-in-org-documents-on-macos/
  (setq org-download-method 'directory)
  (setq org-download-image-dir "images")
  (setq org-download-heading-lvl nil)
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  (setq org-image-actual-width 300)
  (setq org-download-screenshot-method "/opt/homebrew/bin/pngpaste %s")

  (global-set-key (kbd "C-M-y") 'org-download-clipboard)

  ;; elfeed-org
  (setq rmh-elfeed-org-files (list "~/Dropbox/org/elfeed.org")))

;; (setq org-appear-autolinks t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; (load (expand-file-name "~/.quicklisp/slime-helper.el"))
;; (setq inferior-lisp-program "sbcl")


;; mu4e
(after! mu4e
  (setq mail-user-agent 'mu4e-user-agent)
  (setq mu4e-backend 'mbsync)
  (setq mu4e-get-mail-command "mbsync zoia-essential" )
  (setq mu4e-change-filenames-when-moving t)

  ;; remap trash
  ;; https://rakhim.org/fastmail-setup-with-emacs-mu4e-and-mbsync-on-macos/

  (fset 'my-move-to-trash "mTrash")
  (define-key mu4e-headers-mode-map (kbd "d") 'my-move-to-trash)
  (define-key mu4e-view-mode-map (kbd "d") 'my-move-to-trash)


  ;; from https://rakhim.org/fastmail-setup-with-emacs-mu4e-and-mbsync-on-macos/
  (setq
   mu4e-headers-skip-duplicates t
   mu4e-view-show-images t
   mu4e-show-addresses t
   mu4e-compose-format-flowed nil
   mu4e-date-format "%Y-%m-%d"
   mu4e-headers-date-format "%Y-%m-%d"
   mu4e-change-filenames-when-moving t
   mu4e-attachments-dir "~/Downloads"

   mu4e-root-maildir "~/Dropbox/Maildir/zoiaorg"
   mu4e-refile-folder "/Archive"
   mu4e-sent-folder   "/Sent"
   mu4e-drafts-folder "/Drafts"
   mu4e-trash-folder  "/Trash")

  (setq mu4e-use-fancy-chars t)
  ;; update interval. Update every 5 minutes
  (setq mu4e-update-interval 300)
  (setq mu4e-view-use-gnus t)

  ;; make messages look better in dark mode
  (setq shr-color-visible-luminance-min 80)
  ;; mu4e bookmarks
  ;; https://www.djcbsoftware.nl/code/mu/mu4e/MV-Bookmarks.html
  (add-to-list 'mu4e-bookmarks
               '( :name "Mailing Lists"
                  :key ?l
                  :query "body:unsubscribe"))




  ;; contexts for different accounts
  ;;
  ;; (setq mu4e-contexts
  ;;     `( ,(make-mu4e-context
  ;;          :name "zoia-org"
  ;;          :enter-func (lambda () (mu4e-message "Entering zoia.org context"))
  ;;          :leave-func (lambda () (mu4e-message "Leaving zoia.org context"))
  ;;          :match-func (lambda (msg)
  ;;                        (when msg
  ;;                          (mu4e-message-contact-field-matches msg
  ;;                                                              :to "roberto@zoia.org")))
  ;;          :vars '( ( user-mail-address         . "roberto@zoia.org" )
  ;;                   ( user-full-name            . "Roberto Zoia" )
  ;;                   (mu4e-compose-signature     . nil)
  ;;                   ;; server folders
  ;;                   (mu4e-sent-folder           . "/zoia-org/[Gmail].Sent Mail")
  ;;                   (mu4e-drafts-folder         . "/zoia-org/[Gmail].Drafts")
  ;;                   (mu4e-trash-folder          . "/zoia-org/[Gmail].Trash")
  ;;                   (mu4e-refile-folder         . "/zoia-org/[Gmail].All Mail")))
  ;;       ,(make-mu4e-context
  ;;          :name "robertozoia-gmail"
  ;;          :enter-func (lambda () (mu4e-message "Entering roberto.zoia@gmail context"))
  ;;          :leave-func (lambda () (mu4e-message "Leaving roberto.zoia@gmail context"))
  ;;          :match-func (lambda (msg)
  ;;                        (when msg
  ;;                          (mu4e-message-contact-field-matches msg
  ;;                                                            :to "roberto.zoia@gmail.com")))
  ;;          :vars
  ;;          '( (user-mail-address        . "roberto.zoia@gmail.com")
  ;;             (user-full-name           . "Roberto Zoia")
  ;;             (mu4e-compose-signature   . nil)
  ;;             (mu4e-sent-folder         . "/robertozoia-gmail/[Gmail].Sent Mail")
  ;;             (mu4e-drafts-folder       . "/robertozoia-gmail/[Gmail].Drafts")
  ;;             (mu4e-trash-folder        . "/robertozoia-gmail/[Gmail].Trash")
  ;;             (mu4e-refile-folder       . "/robertozoia-gmail/[Gmail].All Mail")))
  ;;       ,(make-mu4e-context
  ;;          :name "robertozoia-icloud"
  ;;          :enter-func (lambda () (mu4e-message "Entering robertozoia@icloud.com context"))
  ;;          :leave-func (lambda () (mu4e-message "Leaving robertozoia@icloud.com context"))
  ;;          :match-func (lambda (msg)
  ;;                         (when msg
  ;;                           (mu4e-message-contact-field-matches msg
  ;;                                                            :to "robertozoia@icloud.com")))
  ;;          :vars
  ;;          '( (user-mail-address        . "robertozoia@icloud.com")
  ;;             (user-full-name           . "Roberto Zoia")
  ;;             (mu4e-compose-signature   . nil)
  ;;             (mu4e-sent-folder         . "/icloud/.Sent Messages")
  ;;             (mu4e-drafts-folder       . "/icloud/Drafts")
  ;;             (mu4e-trash-folder        . "/icloud/Trash")
  ;;             (mu4e-refile-folder       . "/icloud/Archive")))
  ;;       ,(make-mu4e-context
  ;;          :name "rzoia-ideconsac"
  ;;          :enter-func (lambda () (mu4e-message "Entering rzoia@ideconsac.com context"))
  ;;          :leave-func (lambda () (mu4e-message "Leaving rzoia@ideconsac.com context"))
  ;;          :match-func (lambda (msg)
  ;;                         (when msg
  ;;                           (mu4e-message-contact-field-matches msg
  ;;                                                            :to "rzoia@ideconsac.com")))
  ;;          :vars
  ;;          '( (user-mail-address        . "rzoia@ideconsac.com")
  ;;             (user-full-name           . "Roberto Zoia")
  ;;             (mu4e-compose-signature   . nil)
  ;;             (mu4e-sent-folder           . "/rzoia-ideconsac/[Gmail].Sent Mail")
  ;;             (mu4e-drafts-folder         . "/rzoia-ideconsac/[Gmail].Drafts")
  ;;             (mu4e-trash-folder          . "/rzoia-ideconsac/[Gmail].Trash")
  ;;             (mu4e-refile-folder         . "/rzoia-ideconsac/[Gmail].All Mail")))
  ;;       ,(make-mu4e-context
  ;;          :name "rzoia-8c"
  ;;          :enter-func (lambda () (mu4e-message "Entering rzoia@8consultores.com context"))
  ;;          :leave-func (lambda () (mu4e-message "Leaving rzoia@8consultores.com context"))
  ;;          :match-func (lambda (msg)
  ;;                         (when msg
  ;;                           (mu4e-message-contact-field-matches msg
  ;;                                                            :to "rzoia@8consultores.com")))
  ;;          :vars
  ;;          '( (user-mail-address        . "rzoia@8consultores.com")
  ;;             (user-full-name           . "Roberto Zoia")
  ;;             (mu4e-compose-signature   . nil)
  ;;             (mu4e-sent-folder           . "/zoia-8c/[Gmail].Sent Mail")
  ;;             (mu4e-drafts-folder         . "/zoia-8c/[Gmail].Drafts")
  ;;             (mu4e-trash-folder          . "/zoia-8c/[Gmail].Trash")
  ;;             (mu4e-refile-folder         . "/zoia-8c/[Gmail].All Mail")))

  ;;          ))



  ;; set `mu4e-context-policy` and `mu4e-compose-policy` to tweak when mu4e should
  ;; guess or ask the correct context
  ;;
  ;; Start with the first (default) context;
  ;; default is to ask-if-none
  ;;   (setq mu4e-context-policy 'pick-first)
  ;;
  ;; compose with the current context if no context matches
  ;; default is to ask
  ;; (setq mu4e-compose-context-policy nil)
  ;;
  ;;
  (setq message-kill-buffer-on-exit t)
  ;; (setq mu4e-org-link-query-in-headers-mode nil)

  ;; enable inline images
  (setq mu4e-view-show-images t)
  ;; (setq mu4e-view-use-gnus t)
  ;; use imagemagik when available
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

  ;; msmtp
  (setq sendmail-program "/opt/homebrew/bin/msmtp"
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function 'message-send-mail-with-sendmail
        ;;smtpmail-queue-dir "~/Dropbox/Maildir/message-queue"
      )

  )

;;
;; IDE - Programming
;;
(global-set-key [f8] 'neotree-toggle)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packagesrwith
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;
;; TailwindCSS
;; https://github.com/merrickluo/lsp-tailwindcss
(use-package! lsp-tailwindcss)

;; https://learnings.desipenguin.com/post/vuejs-with-doom-emacs-nvm/
(add-hook 'vue-mode-hook #'lsp!)
