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

function read_structure_of_table
{
  line=$(head -1 $tb_name)
  IFS=':' read -r -a names <<< "$line"
  
  line1=$(head -2 $tb_name | tail -1)
  IFS=':' read -r -a types <<< "$line1"
}

function repeat_pk_value
{
  mapfile -t pks < <(cut -d\| -f1 $tb_name | tail -n +3)
  #echo $pks
  #IFS=' ' read -r -a arr <<< "$pks"
  #echo ${arr[1]}
	found=1
	for col in "${pks[@]}"
	do
    if [[ "${types[0]}" = "number" ]]; then
      A=$(printf "%s" "$1"|tr -dc '[:digit:]')
      if [[ "$col" = "$A" ]]; then
        found=0;
      fi
    else
      if [[ "$col" = "$1" ]]; then
        found=0;
      fi
    fi    
	done
  echo 
	return $found
}

function read_pk_value_and_check
{
  if [[ "${types[0]}" = "number" ]]; then
    rg='^[0-9]+$';
  else
    rg='^[a-zA-Z]+$';
  fi
  echo "enter pk column value"
  read pk
  if test -z "$pk"; then
    echo "column name mustn\`t be empty"
    echo "try again";
  elif ! [[ $pk =~ $rg ]] ; then
    echo "pk value must achieve datatype constrain"
    echo  " try again!"
  elif ! repeat_pk_value "$pk"; then
    echo "This pk does n\` exist "
    echo " Please try exist pk!"
    . ../enter_db.sh ;
  else
    row_value+=("$pk|")
  fi
}

function read_the_rest_of_row
{
  col_num=${#names[@]};
  for ((i=2; i<=col_num; i++))
  do
    if [[ "${types[$i]}" = "number" ]]; then
      rg='^[0-9]+$';
    else
      rg='^[a-zA-Z]+$';
    fi
	  echo "enter column $i value"
    while ((1))
    do
      read col_name
      if test -z "$col_name"; then
      echo "column value mustn\`t be empty"
      echo "try again";
      elif ! [[ $col_name =~ $rg ]] ; then
        echo "column value must acchieve datatype constrain"
        echo  " try again!"
      else
        row_value+=("$col_name|") 
        break;
      fi
    done
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
    if ! check_Tb_exist; then
      echo
      echo "Table does n\`t exist"
    else
      echo
      echo "update row in table $tb_name"
      echo
      read_structure_of_table
      read_pk_value_and_check
      read_the_rest_of_row
      
      echo "${row_value[@]}"
      row_data=""
      for col in "${row_value[@]}"
      do
        row_data+=$col;
      done
      #echo $row_data
      sed -i 's/^'"$pk"'|.*/'"$row_data"'/' "$tb_name"
      echo
      echo "row updated successfully=============="
      row_value=()
    fi
    ;;
  *)
    echo
    echo "error Table name"
esac
names=()
types=()
. ../show_tb_menu.sh
