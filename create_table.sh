#!/bin/bash
LC_ALL=C
shopt -s extglob

function check_Tb_exist
{
  if [ -d "$tb_name" ]; then
    return 0;
  else
    return 1;
  fi
}

function read_and_check_col_number
{
  rg='^[0-9]+$';
  while true; do
    echo "enter number of columns"
    read col_num
    if test -z "$col_num"; then
      echo "column number mustn\`t be empty"
    elif ! [[ $col_num =~ $rg ]] ; then
      echo "column number must be number nothing else";
    elif [ "$col_num" -eq 0 ]; then
      echo "column number must be greater than zero";
    else
      echo "your number ==>> " $col_num;
      break;
    fi
  done
}

function repeat_column_name
{
	found=1
	for col in "${names[@]}"
	do
		if [[ "$col" = "$1" ]]
		then found=0
		fi
	done
	return $found
}

function read_and_check_pk
{
  rg='^[a-zA-Z]+$';
  while true; do
    echo "enter pk column name"
    read pk
    if test -z "$pk"; then
      echo "column name mustn\`t be empty"
      echo "try again";
    elif ! [[ $pk =~ $rg ]] ; then
      echo "pk name must be alphabite characters only"
      echo  " try again!"
    elif repeat_column_name "$pk"; then
      echo "This name is taken before for other column"
      echo " Please try again!"
    else
      names+=("$pk") 
      break;
    fi
  done
}

function read_pk_type
{
  echo "enter pk column type (string, number)"
  read pktype
  while ((1))
  do
    case $pktype in     
      string) break;;
      number) break ;;
      *)
        echo "Please specify type as number or string!"
        echo "enter pk column name"
        read pktype
        ;;
    esac
  done
  types+=("$pktype")
}

function read_table_culomns
{
  for ((i=2; i<=col_num; i++))
  do
	  echo "column $i name"
    while ((1))
    do
      read col_name
      if test -z "$col_name"; then
      echo "column name mustn\`t be empty"
      echo "try again";
      elif ! [[ $col_name =~ $rg ]] ; then
        echo "pk name must be alphabite characters only"
        echo  " try again!"
      elif repeat_column_name "$col_name"; then
        echo "This name is taken before for other column"
        echo " Please try again!"
      else
        names+=("$col_name") 
        break;
      fi
    done
    echo "column $i type (string, number)"
    read type
    while ((1))
    do
      case $type in
        number) break;;
        string) break;;
        *)
          echo "Please specify type as number or string or mixed"
          read type
          ;;
      esac
    done
    types+=($type)
  done
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
      echo "Table allready exist"
    else
      read_and_check_col_number
      read_and_check_pk
      read_pk_type
      read_table_culomns
      for ((i=0; i<col_num-1; i++))
    	do
        printf '%s' "${names[$i]}:" >> "${tb_name}"
 	    done
       printf '%s\n' "${names[$col_num-1]}" >> "${tb_name}"
      for ((i=0; i<col_num-1; i++))
    	do
        printf '%s' "${types[$i]}:" >> "${tb_name}"
 	    done
        printf '%s\n' "${types[$col_num-1]}" >> "${tb_name}"
      touch $tb_name;
      echo
      echo "Table created successfully =============================";
      echo $tb_name "table are created successfully!"
    fi
    ;;
  *)
    echo
    echo "error Table name"
esac
names=()
types=()
. ../show_tb_menu.sh
