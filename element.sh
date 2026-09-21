#!/bin/bash


if [[ $# -lt 1 ]]; then
  echo "Please provide an element as an argument."
  exit 
fi

PSQL="psql -X --username=freecodecamp --tuples-only --dbname=periodic_table  -c"
USER_INPUT=$1
# if input is number
if [[ $USER_INPUT =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$USER_INPUT'")
# if input is a string that's less than lenght 3
elif [[ ${#USER_INPUT} -le 2 ]]; then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$USER_INPUT'")
# if input is a string
elif [[ ${#USER_INPUT} -gt 3 ]]; then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$USER_INPUT'")
else
  echo "Incorrect format."
fi

if [[ -z $ATOMIC_NUMBER ]]; then 
  echo "I could not find that element in the database."
  exit
fi

RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM elements INNER JOIN properties ON elements.atomic_number = properties.atomic_number WHERE elements.atomic_number = $ATOMIC_NUMBER")
echo $RESULT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE_ID; do 
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  
  # Remove leading and trailing whitespaces
  ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed 's/^ *| *$//g'); 
  NAME=$(echo $NAME | sed 's/^ *| *$//g'); 
  SYMBOL=$(echo $SYMBOL | sed 's/^ *| *$//g'); 
  TYPE=$(echo $TYPE | sed 's/^ *| *$//g'); 
  ATOMIC_MASS=$(echo $ATOMIC_MASS | sed 's/^ *| *$//g'); 
  MELTING_POINT_CELSIUS=$(echo $MELTING_POINT_CELSIUS | sed 's/^ *| *$//g'); 
  BOILING_POINT_CELSIUS=$(echo $BOILING_POINT_CELSIUS | sed 's/^ *| *$//g'); 
  
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
done
