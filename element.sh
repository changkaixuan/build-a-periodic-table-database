#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
	echo "Please provide an element as an argument."
else
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
		RESULT=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
		if [[ -z $RESULT ]]
		then
			RESULT=$($PSQL "SELECT name FROM elements WHERE name='$1'")
			if [[ -z $RESULT ]]
			then
				echo "I could not find that element in the database."
			else
				SEARCH='name'
			fi
		else
			SEARCH='symbol'
		fi
  else
    RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number="$1" ")
    if [[ -z $RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      SEARCH=atomic_number
    fi
  fi
  if [[ $SEARCH ]]
  then
    DATA=$($PSQL "SELECT * FROM properties INNER JOIN types USING(type_id) INNER JOIN elements USING(atomic_number) WHERE $SEARCH='$1'")
    echo "$DATA" | while IFS="|" read ATOMIC_NUMBER TYPE_ID ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE SYMBOL NAME
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi
