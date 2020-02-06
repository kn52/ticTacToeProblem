#!/bin/bash -x
readonly ROWS=3
readonly COLUMNS=3
declare -A board
random()
{
	randomValue=$((RANDOM%2))
	echo $randomValue
}
resetGame()
{
	for ((i=0;i<$ROWS;i++))
	do
		for ((j=0;j<$COLUMNS;j++))
		do
			board[$i,$j]=""
		done
	done
}

letterAssign()
{
	randomNumber=$( random )
	if (( $randomNumber == 0 ))
	then
		letter="X"
		turn=1
	else
		letter="O"
		turn=2
	fi
}

displayBoard()
{
	for ((i=0;i<$ROWS;i++))
	do
		for ((j=0;j<$COLUMNS;j++))
		do
				printf " ${board[$i,$j]} "
			if (( $j < $(( $COLUMNS - 1 )) ))
			then
				printf "|"
			fi
		done
		echo
		if (( $i < $(( $ROWS - 1 )) ))
		then 
			k=0
			while (( $k < $(( $(($ROWS*4)) - 1 )) ))
			do
				printf "-"
				((k++))
			done
			echo
		fi
	done
}

resetGame
letterAssign
displayBoard










