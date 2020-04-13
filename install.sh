#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

VERBOSE=false
while getopts ":v" opt
do
    case "$opt" in
        v)
            VERBOSE=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done


function setup_logging() {
  SEED="$(date "+%Y%m%d%H%M%S").$$"
  local log_path="/tmp/install.${SEED}.log"
  exec 4<> "$log_path" # open the log file at fd 4
  if $VERBOSE; then
    tail -f "$log_path" &
    TAIL_PID=$!
    trap 'kill $TAIL_PID' SIGINT SIGTERM EXIT
  fi
}


function run_os_specific_scripts {
  # shellcheck source=utils/os_type.sh
  source "$DIR"/utils/os_type.sh  # get os type
  echo "========= operating system $OS"
  shopt -s nocasematch
  if [[ $OS =~ ubuntu  ]]
  then
    local script_dir=$DIR/distro/ubuntu
  elif [[  $OS =~ centos ]]
  then
    local script_dir=$DIR/distro/centos
  else
    echo "\$OS=$OS does not have os specific packages"
  fi
  if [[ -n $script_dir ]]
  then
    echo "========= install scripts from $script_dir"
    for script in $(find "$script_dir" -type f -name "*.sh" -exec basename {} \; | sort | grep -Ev '^_')
    do
      echo "========= run install $script_dir/$script"
      # shellcheck source=/dev/null
      source "$script_dir/$script"
      if check
      then
        echo "already provisioned. do nothing!"
      else
        time provision 2>&1 >&4
        check && echo succeed! || echo fail! >&2
      fi
    done
  fi
}


function install_python_utils {
  sudo /usr/local/bin/pip3 install -U pip
  sudo /usr/local/bin/pip3 install virtualenv virtualenvwrapper pipenv flake8 black httpie pynvim
}


function install_nix {
  curl https://nixos.org/nix/install | sh
}


function nix_install_packages {
  # shellcheck source=/dev/null
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  nix-env -i tmux ripgrep fd inotify-tools fzf ctags
}


function configure_dev_environment {
  "$DIR"/configure.sh
}


setup_logging
run_os_specific_scripts
install_python_utils
install_nix
nix_install_packages
configure_dev_environment
