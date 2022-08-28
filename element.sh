#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  elements=$($PSQL "SELECT * FROM elements ORDER BY atomic_number;")
  max_atomic_number=$($PSQL "SELECT MAX(atomic_number) FROM elements;")
  echo "$elements" | while IFS="|" read atomic_number symbol name
  do
    if [[ $1 -eq $atomic_number ]] || [[ $1 == $symbol ]] || [[ $1 == $name ]]
    then
      atomic_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $atomic_number")
      melting_point_celsius=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $atomic_number")
      boiling_point_celsius=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $atomic_number")
      type=$($PSQL "SELECT type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number=$atomic_number")
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
      break
    fi
    if [[ $atomic_number -eq $max_atomic_number ]]
    then
      echo "I could not find that element in the database."
    fi
  done
fi