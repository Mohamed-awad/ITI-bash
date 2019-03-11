#!/bin/bash
LC_ALL=C
shopt -s extglob

function check_db_exist
{
  if [ -d "$db_name" ]; then
    return 0;
  else
    return 1;
  fi
}

clear
echo "please Enter db name";
IFS= read -r db_name

case $db_name in
  #validate the db name not have space
  *\ *)
    echo
    echo "db name must have no spaces"
    ;;
  +([[:digit:]]))
    echo
    echo "db name must have no digits"
    ;;
  +([a-zA-Z]))
    if check_db_exist; then
       rm -R $db_name;
      echo
      echo "db deleted successfully =============================";
    else
     echo
      echo "db does not exist"
    fi
    ;;
  *)
    echo
    echo "error db name"
esac
names=()
types=()
. ./show_db_menu.sh
