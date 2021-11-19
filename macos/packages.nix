{ pkgs }:

with pkgs; 
let common-packages = import ../common/packages.nix { pkgs = pkgs; }; in 
common-packages ++ [
 jq
 tree
 vim
 wget
 zip
]