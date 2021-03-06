;;;================================= loptimus' .emacs =================================
; Environment variable
;(setenv "Environment Variable Name" "Environment Variable Value")
;(defvar Variable (getenv "Environment Variable Name"))

; Stack trace on error
(setq stack-trace-on-error t)

; Default directory
;(defvar workspace "D:/workspace")
;(setq default-directory workspace)
;(cd workspace)

(setq exec-path (cons "/usr/local/bin" exec-path)) 

;;;================================= Info =================================
(setq user-full-name "loptimus")
(setq user-mail-address "loptimus2510@gmail.com")

;(setenv "PATH" (concat (getenv "PATH") ":~/.emacs.d/commonIDE/cscope/bin"))
;(setq tags-file-name "/root/etags/ERL_LIB_TAGS")

;;;================================= Emacs base configure =================================
;;; Custom
(load-library "~/.emacs.d/utils_conf.el")
(load-library "~/.emacs.d/keymap_conf.el")
(require 'utils_conf)  ; 自定义函数
(require 'keymap_conf)  ; Keymap 快捷键配置
(add-to-list 'load-path "~/.emacs.d/baseConf")
(require 'base_conf)

;;;================================= Emacs common IDE configure =================================
(add-to-list 'load-path "~/.emacs.d/commonConf")
(defvar autoCompletePath "~/.emacs.d/commonConf/auto-complete-1.3.1")
(defvar cedetPath "~/.emacs.d/commonConf/cedet-1.1")
(defvar ecbPath "~/.emacs.d/commonConf/ecb-2.40")
(defvar yasnippetPath "~/.emacs.d/commonConf/yasnippet")
(defvar cscopePath "~/.emacs.d/commonConf/cscope")
(require 'common_conf)

;;;================================= orgMode configure =================================
(defun org () "Load org-mode"
  (defvar orgModePath "~/.emacs.d/orgMode")
  (add-to-list 'load-path orgModePath)
  (require 'org-install)
)

;;;================================= Erlang configure =================================
(add-to-list 'load-path "~/.emacs.d/erlangConf/")
;; Erlang
(defvar erlangPath "/usr/local/lib/erlang")
(defvar erlangEmacsPath "~/.emacs.d/erlangConf/emacs")
;; Distel
(defvar distelPath "~/.emacs.d/erlangConf/distel-4.03/elisp")
;; Refactorerl
;; (defvar refactorerlPath "~/.emacs.d/erlIDE/refactorerl-0.9.12.05")
;; Wrangler
;;(defvar wranglerPath "/usr/local/share/wrangler")
(require 'erlang_conf)

;;;================================= C/Cpp configure =================================
(add-to-list 'load-path "~/.emacs.d/cppConf/")
(require 'cpp_conf)

;;;================================= PHP configure ======================================
(defvar phpPath "~/.emacs.d/phpConf")
(add-to-list 'load-path phpPath)
(require 'php_conf)

;; 加载插件
(defun load-plugin (plugin)
      "手动加载指定插件 M-x load-plugin"
      (interactive "s请输入要加载的插件：")
      (cond 
       ((string-equal plugin "ac") (ac))
       ((string-equal plugin "cedet") (cdt))
       ((string-equal plugin "ecb") (ecb))
       ((string-equal plugin "org") (org))
       ((string-equal plugin "php") (php))
       ((string-equal plugin "cscope") (cscope))
       ((string-equal plugin "yas") (yas))
       ((string-equal plugin "undo-tree") (undo-tree))
       (t (message "没有找到插件：%s" plugin))
      )      
)

;; 自动加载插件
(defun auto-load-plugin () "启动时自动加载的插件"
  (ac)
  ;(cdt)
  ;(ecb)
  (undo-tree)
)

;; 调用自动加载函数
(auto-load-plugin)

;; 启用自定义快捷键
(default_keymap)
(utils_keymap)
