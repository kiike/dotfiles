;; base16-material-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Authors:
;; Scheme: Jan T. Sott (http://github.com/idleberg)
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-material-colors
  '(:base00 "#000000"
    :base01 "#202020"
    :base02 "#404040"
    :base03 "#a0a0a0"
    :base04 "#b0b0b0"
    :base05 "#fff3e0"
    :base06 "#f0f0f0"
    :base07 "#fff3e0"
    :base08 "#ff8a80"
    :base09 "#ff9800"
    :base0A "#f4ff81"
    :base0B "#ccff90"
    :base0C "#84ffff"
    :base0D "#82b1ff"
    :base0E "#ff80ab"
    :base0F "#ff9800")
  "All colors for Base16 material are defined here.")

;; Define the theme
(deftheme base16-material)

;; Add all the faces to the theme
(base16-theme-define 'base16-material base16-material-colors)

;; Mark the theme as provided
(provide-theme 'base16-material)

(provide 'base16-material-theme)

;;; base16-material-theme.el ends here
