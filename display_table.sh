#!/bin/bash
LC_ALL=C
shopt -s extglob

function check_Tb_exist
{
  if [ -f "$tb_name" ]; then
    return 0;
  else
    return 1;
  fi
}

clear
echo "please Enter table name";
echo "table name must be lower or upper case letters or mix only"
IFS= read -r tb_name
case $tb_name in
  #validate the tb name not have space
  *\ *)
    echo
    echo "tb name must have no spaces"
    ;;
  +([[:digit:]]))
    echo
    echo "tb name must have no digits"
    ;;
  +([a-zA-Z]))
    if check_Tb_exist; then
      echo
      echo "data of table $tb_name"
      echo "---------------------------------------------------------------------------------------"
      head -1 $tb_name
      echo "---------------------------------------------------------------------------------------"
      awk 'NR > 2 { print }' $tb_name
      echo "---------------------------------------------------------------------------------------"
    else
      echo
      echo "Table does not exist"
    fi
    ;;
  *)
    echo
    echo "error Table name"
esac
names=()
types=()
. ../show_tb_menu.sh
