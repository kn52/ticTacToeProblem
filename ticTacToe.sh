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

	else
		letter="O"
	fi
}
firstChance()
{
	read -p "Enter your choice [H/T]: " choice
	if (( "${toss[$((RANDOM%2))]}" == "$choice"  ))
	then
		turn=1
	else
		turn=2
	fi 
}

resetGame
letterAssign










