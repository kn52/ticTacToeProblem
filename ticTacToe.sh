#!/bin/bash
readonly ROWS=3
readonly COLUMNS=3
readonly EMPTY=5
declare -A board

boolean=5
choice=1
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
			board[$i,$j]="5"
		done
	done
}

letterAssign()
{
	randomNumber=$( random )
	if (( $randomNumber == 0 ))
	then
		letter="X"
		playerTurn=1
	else
		letter="O"
		playerTurn=1
	fi
}
#isWinnerInRow
isWinnerInRow()
{
	num=0
	val=$(( $playerTurn * 3 ))
	for ((i=0;i<$ROWS;i++))
	do
		j=0
		num=$(( ${board[$i,$j]} + ${board[$i,$((j+1))]} + ${board[$i,$((j+2))]} ))
		if (( $num  == $val ))
		then 
			boolean=1
			break
		fi
	done
}
#isWinnerInColumn
isWinnerInColumn()
{
	num=0
	val=$(( $playerTurn * 3 ))
	for ((i=0;i<$ROWS;i++))
	do
		j=0
		num=$(( ${board[$j,$i]} + ${board[$((j+1)),$i]} + ${board[$((j+2)),$i]} ))
		if (( $num  == $val ))
		then 
			boolean=1
			break
		fi
	done
}
#isWinnerInDiagonal
isWinnerInDiagonal()
{
	val=$(( $playerTurn * 3 ))
	if (( $(( ${board[0,0]} + ${board[1,1]} + ${board[2,2]} )) == $val ))
	then 
		boolean=1
	elif (( $(( ${board[2,0]} + ${board[1,1]} + ${board[0,2]} )) == $val ))
	then 
		boolean=1
	fi
}
#isWinner: Checking current player is winner or not
isWinner()
{
	if [[ $boolean == 5 ]]
	then	
		isWinnerInRow
	fi
	if [[ $boolean == 5 ]]
	then
		isWinnerInColumn
	fi
	if [[ $boolean == 5 ]]
	then
		isWinnerInDiagonal
	fi
}
#displayWinner: Displaying winner
displayWinner()
{	
	isWinner
	if (( $boolean == 1 ))
	then
		echo "Won...!!"
		exit
	fi		
}
#input: Assigning values to the board
input()
{
	if (($x<0 || $x>2 || $y<0 || $y>2 ))
	then
		echo "Invalid Move"
	elif (( ${board[$x,$y]} == $EMPTY ))
	then
		((++moves))
		board[$x,$y]=$playerTurn
		displayBoard		
		displayWinner
	else 
		echo "Board is Occupied"
	fi
}
#displayBoard
displayBoard()
{
	for ((i=0;i<$ROWS;i++))
	do
		for ((j=0;j<$COLUMNS;j++))
		do
				printf "   "
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
while (( $choice == 1 ))
do
	read position
	x=$(($position/10))
	y=$(($position%10))
	input
done








