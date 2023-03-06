{ config, pkgs, ... }:

let
  home           = builtins.getEnv "HOME";
  xdg_configHome = "${home}/.config";
  xdg_dataHome   = "${home}/.local/share";
  xdg_stateHome  = "${home}/.local/state"; in
{

  # Raycast script so that "Run Emacs" is available and uses Emacs daemon
  "${xdg_dataHome}/bin/emacsclient" = {
    executable = true;
    text = ''
      #!/bin/zsh
      #
      # Required parameters:
      # @raycast.schemaVersion 1
      # @raycast.title Run Emacs
      # @raycast.mode silent
      #
      # Optional parameters:
      # @raycast.packageName Emacs
      # @raycast.icon ${xdg_dataHome}/img/icons/Emacs.icns
      # @raycast.iconDark ${xdg_dataHome}/img/icons/Emacs.icns

      if [[ $1 = "-t" ]]; then
        # Terminal mode
        ${pkgs.emacs}/bin/emacsclient -t
      else
        # GUI mode
        ${pkgs.emacs}/bin/emacsclient -c
      fi
    '';
  };

  # Script to import Drafts into Emacs org-roam
  "${xdg_dataHome}/bin/import-drafts" = {
    executable = true;
    text = ''
      #!/bin/sh

      for f in ${xdg_stateHome}/drafts/*
      do
        if [[ ! "$f" =~ "done" ]]; then
          echo "Importing $f"
          filename="$(head -c 10 $f)"
          output="${xdg_dataHome}/org-roam/daily/$filename.org"
          echo '\n' >> "$output"
          tail -n +3 $f >> "$output"
          mv $f done
        fi
      done
    '';
  };

}
