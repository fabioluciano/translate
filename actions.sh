#!/bin/bash

distro_version=`lsb_release -is`
usuario=$(printf '%s\n' "${SUDO_USER:-$USER}")
diretorio=$(dirname $0)
parameter="$1"

function initialize() {
  everything_is_ok=0
  check_if_everything_is_alright;

  if [ $everything_is_ok -eq 1 ]; then

    case $parameter in
      check)
         check_if_everything_is_alright
      ;;
      *)
      render_menu;
      exit 1;
    esac
  fi
}

function check_if_everything_is_alright() {
  #Checa se os pacotes necessários para tradução estão instalados
  are_the_necessary_packages_installed
  do_you_have_a_github_account

  everything_is_ok=1
}

function are_the_necessary_packages_installed() {
  necessary_packages=( dialog git svn php )
  missing_packages=()
  iterator=0;

  for package in "${necessary_packages[@]}"; do
    binary_path=$(which $package)

    if [ -z "$binary_path" ]; then
      missing_packages[$iterator]=$package
    fi

    ((iterator++))
  done

  if [ ${#missing_packages[@]} -gt 0 ]; then
    echo -e "\t * Os seguintes pacotes necessários ao processo não estão presentes: \e[31m${missing_packages[@]}\e[39m"
    exit 0;
  fi

  echo -e '\t* \e[32mTodos os pacotes necessários estão instalados\e[39m'
}

function do_you_have_a_github_account() {
  dialog --stdout --title "Github"  --yesno "Você possui conta no github?" 5 50
  have_the_account=$?

  if [ $have_the_account -eq 1 ]; then
    echo "O processo exige uma conta no github! Crie uma em: https://github.com/join"
  else
    echo 'teste'
  fi


  exit $have_the_account;
  # github_account=$(dialog --title "Create Directory" --inputbox "Enter the directory name:" 8 40)
}


function render_menu(){
  option=$( dialog --stdout --title 'Lets translate' --menu 'Selecione uma opção.' 0 0 0 \
    criar_estrutura 'Criar estrutura inicial' \
  )

  case $option in
    criar_estrutura)
      criar_estrutura;
    ;;
  esac
}

initialize
