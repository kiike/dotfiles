set -eu

deploy_system() {
    sudo nixos-rebuild switch --flake ~/dotfiles
}

deploy_home() {
    home-manager switch --flake ~/dotfiles -b backup
}

nix flake update
target=all
if [ $# -gt 0 ]; then
  target=$1
  shift
fi
case $target in
  system|s) deploy_system ;;
  home|h) deploy_home ;;
  all|*)
    deploy_system
    deploy_home
    ;;
esac
