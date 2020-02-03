#!/bin/bash
readonly ROWS=3
readonly COLUMNS=3
declare -A board

echo "Welcome to Tic Tac Toe Problem"

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

resetGame
