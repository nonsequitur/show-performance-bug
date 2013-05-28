(defun patch-orglink ()
  (define-minor-mode orglink-mode
    "Toggle display Org-mode links in other major modes.

On the links the following commands are available:

\\{orglink-mouse-map}"
    :lighter orglink-mode-lighter
    (when (derived-mode-p 'org-mode)
      (error "Orglink Mode doesn't make sense in Org Mode"))
    (cond (orglink-mode
           (org-load-modules-maybe)
           (add-hook 'org-open-link-functions
                     'orglink-heading-link-search nil t)
           (font-lock-add-keywords nil (orglink-font-lock-keywords) t)
           (org-set-local 'org-descriptive-links org-descriptive-links)
           (when org-descriptive-links
             (add-to-invisibility-spec '(org-link)))
           (org-set-local 'font-lock-unfontify-region-function
                          'orglink-unfontify-region)
           (org-set-local 'org-mouse-map orglink-mouse-map))
          (t
           (remove-hook 'org-open-link-functions
                        'orglink-heading-link-search t)
           (font-lock-remove-keywords nil (orglink-font-lock-keywords t))
           (org-remove-from-invisibility-spec '(org-link))
           (kill-local-variable 'org-descriptive-links)
           (kill-local-variable 'font-lock-unfontify-region-function)
           (kill-local-variable 'org-mouse-map)))
    (when font-lock-fontified (font-lock-fontify-buffer))))

;;-----------------------------------------------------------------------------------

(add-to-list 'load-path user-emacs-directory)
(require 'orglink)

(setq huge (concat user-emacs-directory "huge.cc"))
(setq huge-buf "huge.cc")

;; Comment out these two lines and witness another bug
(find-file huge)
(kill-buffer huge-buf)

;;-----------------------------------------------------------------------------------

(add-to-list 'orglink-activate-in-modes 'c++-mode)
(global-orglink-mode)

(benchmark 1 '(find-file huge))
(kill-buffer huge-buf)

(patch-orglink)

(benchmark 1 '(find-file huge))
(kill-buffer huge-buf)

(view-echo-area-messages)
