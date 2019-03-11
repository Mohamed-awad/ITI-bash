#!/bin/bash

function show_dbs
{
  echo
  echo "All DataBases"
  echo "------------------------"
  for i in *
  do
    if [ -d ./"$i" ]; then
      echo "| --> "$i;
    fi
  done
  echo "------------------------"
}

echo "welcome to awad & hesham db engine";
echo 
echo "please choose your query";
echo "---------------------"
select menu in "create db" "show dbs" "use db" "drop db" "exit"
do
  case $REPLY in
    1) . ./create_db.sh
      ;;
    2) show_dbs
      ;;
    3) . ./use_db.sh
      ;;
    4) . ./drop_db.sh
      ;;
    5) echo "exit db engine we will miss you"
       exit;
      ;;
    *)echo "wrong query please choose one of menu"
  esac
done

