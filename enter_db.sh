#!/bin/bash

function show_tables
{
  echo
  echo "All Tables"
  echo "------------------------"
  for i in *
  do
    if [ -f ./"$i" ]; then
      echo "| --> "$i;
    fi
  done
  echo "------------------------"
  . ../show_tb_menu.sh
}

echo "please choose your query";
echo "---------------------"
select menu in "create Table" "show Tables" "describe Table" "delete Table" "display table" "insert into table" "update Row" "display Row" "delete Row" "Back To Main Menu"
do
  case $REPLY in
    1) . ../create_table.sh
      ;;
    2) show_tables;
      ;;
    3) . ../describe_table.sh
      ;;
    4) . ../delete_table.sh
      ;;
    5) . ../display_table.sh
      ;;
    6) . ../insert_into_table.sh
      ;;
    7) . ../update_row.sh
      ;;
    8) . ../display_row.sh
      ;;
    9) . ../delete_row.sh
      ;;
    10) return;
      ;;
    *)echo "wrong query please choose one of menu"
  esac
done

names=()
types=()

