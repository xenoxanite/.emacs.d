

;; The default is 800 kilobytes. Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

(defun efs/org-babel-tangle-config ()
  "Automatically tangle our Emacs.org config file when we save it. Credit to Emacs From Scratch for this one!"
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(require 'use-package-ensure) ;; This line is currenly needed, there is a bug with always-ensure, it doesn't get loaded if we just setq t
(setq use-package-always-ensure t) ;; Always ensures that a package is installed
(setq package-archives '(("melpa" . "https://melpa.org/packages/") ;; Sets default package repositories
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/"))) ;; For Eat Terminal

(use-package evil
  :init ;; Tweak evil's configuration before loading it
  (setq evil-want-keybinding nil) ;; Disable evil bindings in other modes (It's not consistent and not good)
  (setq evil-want-C-u-scroll t) ;; Set  C-u to scrool up
  (setq evil-want-C-i-jump nil) ;; Disables C-i jump
  (setq evil-undo-system 'undo-redo) ;; C-r to redo
  (setq org-return-follows-link  t) ;; Sets RETURN key in org-mode to follow links
  (evil-mode)
  :config
  (evil-set-initial-state 'eat-mode 'insert)) ;; Set initial state in eat terminal to insert mode
(use-package evil-collection
  :after evil
  :config
  ;; Setting where to use evil-collection
  (setq evil-collection-mode-list '(dired ibuffer corfu dashboard))
  (evil-collection-init))
;; Unmap keys in 'evil-maps. If not done, (setq org-return-follows-link t) will not work
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))

(use-package general
  :config
  (general-evil-setup)
  ;; set up 'SPC' as the global leader key
  (general-create-definer start/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; Set leader
    :global-prefix "C-SPC") ;; Access leader in insert mode

  (start/leader-keys
    "." '(find-file :wk "Find file")
    "s" '(save-buffer :wk "save buffer")
    "SPC" '(counsel-M-x :wk "Counsel M-x")
    "TAB" '(comment-line :wk "Comment lines")
    "p" '(projectile-command-map :wk "Projectile command map"))

  (start/leader-keys
    "f" '(:ignore t :wk "Find")
    "f c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "Edit emacs config")
    "f r" '(counsel-recentf :wk "Recent files"))

  (start/leader-keys
    "l" '(:ignore t :wk "Leetcode")
    "l l" '(leetcode :wk "Leetcode problem list")
    "l t" '(leetcode-try :wk "Leetcode test code")
    "l s" '(leetcode-submit :wk "Leetcode submit code")
    "l d" '(leetcode-daily :wk "Leetcode daily problem")
    "l r" '(leetcode-refresh :wk "Leetcode refresh")
    "l q" '(leetcode-quit :wk "Leetcode quit"))


  
  (start/leader-keys
    "b" '(:ignore t :wk "Buffer Bookmarks")
    "b b" '(switch-to-buffer :wk "Switch buffer")
    "b k" '(kill-this-buffer :wk "Kill this buffer")
    "b i" '(ibuffer :wk "Ibuffer")
    "b n" '(next-buffer :wk "Next buffer")
    "b p" '(previous-buffer :wk "Previous buffer")
    "b r" '(revert-buffer :wk "Reload buffer")
    "b j" '(bookmark-jump :wk "Bookmark jump"))

      (start/leader-keys
      "w" '(:ignore t :wk "Windows")
      ;; Window splits
      "w c" '(evil-window-delete :wk "Close window")
      "w n" '(split-window-right :wk "New window")
      "w s" '(evil-window-split :wk "Horizontal split window")
      "w v" '(evil-window-vsplit :wk "Vertical split window")
      ;; Window motions
      "w h" '(evil-window-left :wk "Window left")
      "w j" '(evil-window-down :wk "Window down")
      "w k" '(evil-window-up :wk "Window up")
      "w l" '(evil-window-right :wk "Window right")
      "w w" '(evil-window-next :wk "Goto next window")
      ;; Move Windows
      "w H" '(buf-move-left :wk "Buffer move left")
      "w J" '(buf-move-down :wk "Buffer move down")
      "w K" '(buf-move-up :wk "Buffer move up")
      "w L" '(buf-move-right :wk "Buffer move right"))

  (start/leader-keys
    "d" '(:ignore t :wk "Dired")
    "d v" '(dired :wk "Open dired")
    "d j" '(dired-jump :wk "Dired jump to current"))



  (start/leader-keys
    "h" '(:ignore t :wk "Help") ;; To get more help use C-h commands
    "h r" '((lambda () (interactive)
              (load-file "~/.emacs.d/init.el"))
            :wk "Reload emacs config"))


  (start/leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t w" '(visual-line-mode :wk "Toggle truncated lines (wrap)")
    "t v" '(vterm-toggle :wk "Show Eat terminal")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
    "t t" '(treemacs-select-window :wk "Treemacs toggle")))

(menu-bar-mode -1)           ;; Disable the menu bar
(scroll-bar-mode -1)         ;; Disable the scroll bar
(tool-bar-mode -1)           ;; Disable the tool bar

(delete-selection-mode 1)    ;; You can select text and delete it by typing.
(electric-indent-mode -1)    ;; Turn off the weird indenting that Emacs does by default.
(electric-pair-mode 1)       ;; Turns on automatic parens pairing

(global-auto-revert-mode t)  ;; Automatically reload file and show changes if the file has changed
(global-display-line-numbers-mode 1) ;; Display line numbers
(global-visual-line-mode t)  ;; Enable truncated lines

(setq mouse-wheel-progressive-speed nil) ;; Disable progressive speed when scrolling
(setq scroll-conservatively 10) ;; Smooth scrolling when going down with scroll margin
(setq scroll-margin 8)

(setq make-backup-files nil) ;; Stop creating ~ backup files
(setq org-edit-src-content-indentation 4) ;; Set src block automatic indent to 4 instead of 2.
(setq-default tab-width 4)

;; Move customization variables to a separate file and load it, avoid filling up init.el with unnecessary variables
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(global-set-key [escape] 'keyboard-escape-quit) ;; Makes Escape quit prompts (Minibuffer Escape)
(blink-cursor-mode 0) ;; Don't blink cursor
(add-hook 'prog-mode-hook (lambda () (hs-minor-mode t))) ;; Enable folding hide/show globally

(use-package ewal)
(use-package ewal-doom-themes
  :init
  (load-theme 'ewal-doom-one t))

(use-package doom-modeline
  :init
  (setq doom-modeline-height 40)
  (setq doom-modeline-buffer-encoding nil)
  (doom-modeline-mode))


(define-minor-mode translucent-mode
  "Make the current frame slightly transparent."
  nil
  :global t
  (if translucent-mode
      (set-frame-parameter (selected-frame) 'alpha '(100))
    (set-frame-parameter (selected-frame) 'alpha '(90))))


(set-face-attribute 'default nil :height 130)
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 130)
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font" :height 130)
(set-face-attribute 'variable-pitch nil :font "JetBrainsMono Nerd Font" :height 130)

(setq-default line-spacing 0.12)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)


(use-package dashboard
  :ensure t 
  :init
  (setq initial-buffer-choice 'dashboard-open)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "Emacs Is More Than A Text Editor!")
  ;;(setq dashboard-startup-banner 'logo) ;; use standard emacs logo as banner
  (setq dashboard-startup-banner "/home/fahim/.emacs.d/assets/logo.jpg")  ;; use custom image as banner
  (setq dashboard-center-content nil) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 4)
                          (agenda . 4 )
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :custom
  (dashboard-modify-heading-icons '((recents . "file-text")
                                    (bookmarks . "book"))
  :config
  (dashboard-setup-startup-hook)))

(use-package vterm)

(use-package vterm-toggle
  :after vterm
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                     (let ((buffer (get-buffer buffer-or-name)))
                       (with-current-buffer buffer
                         (or (equal major-mode 'vterm-mode)
                             (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                  (display-buffer-reuse-window display-buffer-at-bottom)
                  (reusable-frames . visible)
                  (window-height . 0.4))))

(use-package projectile
  :config
  (projectile-mode 1)
  :init
  (setq projectile-switch-project-action #'projectile-dired))



(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c C-l")
  :hook (
          (before-save . lsp-format-buffer)
          (before-save . lsp-organize-imports)
          (prog-mode . lsp)
    )
  :commands lsp
  :hook ((c-mode . lsp)
         (c++-mode . lsp)
         (python-mode . lsp)
         (rust-mode . lsp)
		 )
  :config 
  (setq lsp-enable-snippet t
		lsp-inlay-hint-enable t
		lsp-enable-on-type-formatting t
		lsp-headerline-breadcrumb-enable nil))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :init
  (add-hook 'flycheck-mode-hook 'lsp-ui-mode) ;; HACK
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
		lsp-ui-doc-delay 0.2
		lsp-ui-doc-show-with-cursor t
		lsp-ui-doc-show-with-mouse nil
		lsp-ui-doc-position 'at-point
		lsp-ui-doc-border "black"
		flycheck-mode-hook 'lsp-ui-mode
		lsp-ui-flycheck-enable t))

(use-package flycheck   
  :hook
  (prog-mode . flycheck-mode)
)

(use-package yasnippet-snippets
  :hook (prog-mode . yas-global-mode))

(use-package nix-mode
  :hook (nix-mode . lsp)
  :ensure t)

(use-package leetcode
    :config
   (setq leetcode-prefer-language "cpp")
   (setq leetcode-save-solutions t)
   (setq leetcode-directory "~/dev/leetcode/"))


(use-package nerd-icons
  :if (display-graphic-p))

(use-package nerd-icons-dired
  :hook (dired-mode . (lambda () (nerd-icons-dired-mode t))))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-prefix 2)          ;; Minimum length of prefix for auto completion.
  (corfu-popupinfo-mode t)       ;; Enable popup information
  (corfu-popupinfo-delay 0.5)    ;; Lower popupinfo delay to 0.5 seconds from 2 seconds
  :config
  (setq completion-ignore-case  t)
  ;; Enable indentation+completion using the TAB key.
  ;; `completion-at-point' is often bound to M-TAB.
  (setq tab-always-indent 'complete)
  (setq corfu-preview-current nil) ;; Don't insert completion without confirmation

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode))

(use-package nerd-icons-corfu
  :after corfu
  :init (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape
  :after corfu
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-to-list 'completion-at-point-functions #'cape-file) ;; Path completion
  (add-to-list 'completion-at-point-functions #'cape-elisp-block) ;; Complete elisp in Org or Markdown mode
  (add-to-list 'completion-at-point-functions #'cape-keyword) ;; Keyword/Snipet completion
  (add-to-list 'completion-at-point-functions #'cape-dict) ;; Dictionary completion

  ;;(add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-history)
  ;;(add-to-list 'completion-at-point-functions #'cape-tex)
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-elisp-symbol)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)
  )

(use-package ivy
  :bind
  (("C-c C-r" . ivy-resume) ;; Resumes the last Ivy-based completion.
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode))

(use-package ivy-rich ;; This gets us descriptions in M-x.
  :init (ivy-rich-mode 1))

(use-package nerd-icons-ivy-rich ;; Adds icons to M-x.
  :init (nerd-icons-ivy-rich-mode 1))

(use-package counsel
  :diminish
  :config (counsel-mode))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package diminish)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init
    (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
	  which-key-sort-order #'which-key-key-order
	  which-key-allow-imprecise-window-fit nil
	  which-key-sort-uppercase-first nil
	  which-key-add-column-padding 1
	  which-key-max-display-columns nil
	  which-key-min-display-lines 6
	  which-key-side-window-slot -10
	  which-key-side-window-max-height 0.25
	  which-key-idle-delay 0.8
	  which-key-max-description-length 25
	  which-key-allow-imprecise-window-fit nil
	  which-key-separator " → " ))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
;; Increase the amount of data which Emacs reads from the process
(setq read-process-output-max (* 1024 1024)) ;; 1mb


;;;###autoload
(defun buf-move-up ()
  "Swap the current buffer and the buffer above the split.
If there is no split, ie now window above the current one, an
error is signaled."
;;  "Switches between the current buffer, and the buffer above the
;;  split, if possible."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'up))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No window above this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-down ()
"Swap the current buffer and the buffer under the split.
If there is no split, ie now window under the current one, an
error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'down))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (or (null other-win) 
            (string-match "^ \\*Minibuf" (buffer-name (window-buffer other-win))))
        (error "No window under this one")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-left ()
"Swap the current buffer and the buffer on the left of the split.
If there is no split, ie now window on the left of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'left))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No left split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))

;;;###autoload
(defun buf-move-right ()
"Swap the current buffer and the buffer on the right of the split.
If there is no split, ie now window on the right of the current
one, an error is signaled."
  (interactive)
  (let* ((other-win (windmove-find-other-window 'right))
	 (buf-this-buf (window-buffer (selected-window))))
    (if (null other-win)
        (error "No right split")
      ;; swap top with this one
      (set-window-buffer (selected-window) (window-buffer other-win))
      ;; move this one to top
      (set-window-buffer other-win buf-this-buf)
      (select-window other-win))))
