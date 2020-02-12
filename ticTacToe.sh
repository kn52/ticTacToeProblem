#!/bin/bash
readonly ROWS=3
readonly COLUMNS=3
readonly MAX_COUNT=3
readonly MAXIMUM_NUMBER=2
readonly EMPTY=5
declare -A board
count=0
booleanCount=0
choice=1
flag=0
currentPlayerTurn=1
moves=0
boolean=5
position=-1
cm=0
flag=0
echo "Welcome to Tic Tac Toe Problem"
#initialize
initialize()
{
	row=$1
	column=$2
}
#resetBoard: To initialize board or for fresh start
resetBoard()
{
	for ((i=0;i<$ROWS;i++))
	do
		for ((j=0;j<$COLUMNS;j++))
		do
			board[$i,$j]=5
		done
	done
}
#show: Letter and Turn assign
show()
{
	echo "computerLetter: $computerLetter"
	echo "opponentLetter: $opponentLetter"
	echo "computerTurn: $computerTurn"
	echo "opponentTurn: $opponentTurn"
}
#assignLetter: To assign letter X or O
assignLetter()
{
	local randomNumber=$((RANDOM%2))
	if (( $randomNumber == 0 ))
	then
		opponentLetter="X"
		computerLetter="O"
		opponentTurn=1
		computerTurn=2
	else
		computerLetter="X"
		opponentLetter="O"
		computerTurn=1
		opponentTurn=2
	fi
	show
}
#displayBoard: Displaying the board
displayBoard()
{
	for ((i=0;i<$ROWS;i++))
	do
		for ((j=0;j<$COLUMNS;j++))
		do
			if (( ${board[$i,$j]} == $opponentTurn ))
			then
				printf " $opponentLetter "
			elif (( ${board[$i,$j]} == $computerTurn ))
			then
				printf " $computerLetter "
			else
				printf "   "
			fi
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
#isWinnerInRow
isWinnerInRow()
{
	num=0
	val=$(( $currentPlayerTurn * 3 ))
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
	val=$(( $currentPlayerTurn * 3 ))
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
	val=$(( $currentPlayerTurn * 3 ))
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
	boolean=5 #5 as a false and 1 as true
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
	if (( $boolean == 1 && $currentPlayerTurn == $computerTurn ))
	then
		echo "Computer wins...!!"
		choice=0
		exit
	elif (( $boolean == 1 && $currentPlayerTurn == $opponentTurn))
	then
		echo "You wins...!!"
		choice=0
		exit
	elif (( $boolean == $EMPTY && $moves == 9))
	then
		echo "its a tie"
		choice=0
		exit
	fi
}
#changeTurn: To change player turn
changeTurn()
{
	if [[ $currentPlayerTurn -eq $opponentTurn ]]
	then
		currentPlayerTurn=$computerTurn
	elif [[ $currentPlayerTurn -eq $computerTurn ]]
	then
		currentPlayerTurn=$opponentTurn
	fi
}
#inputBoard: Assigning values to the board
inputBoard()
{
	if (( $row < 0 || $row > 2 || $column < 0 || $column > 2 ))
	then
		echo "Invalid Move"
	elif (( ${board[$row,$column]} == $EMPTY ))
	then
		((++moves))
		board[$row,$column]=$currentPlayerTurn
		displayBoard
		displayWinner
		changeTurn
	else
		echo "Board is Occupied"
	fi
}
#computerSmartMoveInRow
computerSmartMoveInRow()
{
	letter=$1
	emptyCount=0
	letterCount=0
	for ((i=0;i<$ROWS;i++))
	do
		emptyCount=0
		letterCount=0
		for ((j=0;j<$COLUMNS;j++))
		do
			if [[ ${board[$i,$j]} -eq 5 ]]
			then
				rowValue=$i
				columnValue=$j
				((emptyCount++))
			fi
			if [[ ${board[$i,$j]} -eq $letter ]]
			then
				((letterCount++))
			fi
			if (( $emptyCount == 1 && $letterCount == 2 ))
			then
				flag=1
				initialize $rowValue $columnValue
				inputBoard
				return
			fi
		done
	done
}
#computerSmartMoveInColumn
computerSmartMoveInColumn()
{
	letter=$1
	emptyCount=0
	letterCount=0
	for ((i=0;i<$ROWS;i++))
	do
		emptyCount=0
		letterCount=0
		for ((j=0;j<$COLUMNS;j++))
		do
			if [[ ${board[$j,$i]} -eq 5 ]]
			then
				rowValue=$j
				columnValue=$i
				((emptyCount++))
			fi
			if [[ ${board[$j,$i]} -eq $letter ]]
			then
				((letterCount++))
			fi
			if (( $emptyCount == 1 && $letterCount == 2 ))
			then
				flag=1
				initialize $rowValue $columnValue
				inputBoard
				return
			fi
		done
	done
}
#computerSmartMoveInDiagonal
computerSmartMoveInDiagonal()
{
	letter=$1
	local emptyCount1=0
	local emptyCount2=0
	local letterCount1=0
	local letterCount2=0
	for ((i=0;i<$ROWS;i++))
	do
		for ((j=0;j<$COLUMNS;j++))
		do
			if (( $i == $j ))
			then
				if [ ${board[$i,$j]} -eq 5 ]
				then
					rowValue=$i
					columnValue=$j
					((emptyCount1++))
				fi
				if (( ${board[$i,$j]} == $letter ))
				then
					((letterCount1++))
				fi
				if (( $emptyCount1 == 1 && $letterCount1 == 2 ))
				then
					flag=1
					initialize $rowValue $columnValue
					inputBoard
					return
				fi
			fi
			if (( $(($i+$j)) == 2 ))
			then
				if [[ ${board[$i,$j]} -eq 5 ]]
				then
					rowValue1=$i
					columnValue1=$j
					((emptyCount2++))
				fi
				if (( ${board[$i,$j]} == $letter ))
				then
					((letterCount2++))
				fi
				if (( $emptyCount2 == 1 && $letterCount2 == 2 ))
				then
					flag=1
					initialize $rowValue1 $columnValue1
					inputBoard
					return
				fi
			fi
		done
	done
}
#computerCorner: Search for corner to be empty
computerCorner()
{
	for (( i=0;i<$ROWS;i=$((i+2)) ))
	do
		for (( j=0;j<$COLUMNS;j=$((j+2)) ))
		do
			if (( ${board[$i,$j]} == 5 ))
			then
				row=$i
				column=$j
				flag=1
				break
			fi
		done
	done
	inputBoard
}
#computerCentre: Search for centre to be empty
computerCentre()
{
	if (( ${board[1,1]} == 5 ))
	then
		row=1
		column=1
		flag=1
	fi
	inputBoard
}
#computerSide: Search for side to be empty
computerSide()
{
	for (( i=0;i<$ROWS;i++ ))
	do
		for (( j=0;j<$(($COLUMNS-1));j++ ))
		do
			if [[ $i -eq 0 || $i -eq $(($COLUMNS-1)) ]]
			then
				if [[ $j -gt 0 || $j -lt $(($COLUMNS-1)) ]]
				then
					if [[ ${board[$i,$j]} -eq $EMPTY ]]
					then
						initialize $i $j
						flag=1
						break
					fi
				fi
			else
				if [[ $j -eq 0 || $j -eq $(($COLUMNS-1)) ]]
				then
					if [[ ${board[$i,$j]} -eq $EMPTY ]]
					then
						initialize $i $j
						flag=1
						break
					fi
				fi
			fi
		done
		if [[ $flag -eq 1 ]]
		then
			break
		fi
	done
	inputBoard
}
#computerSmartMove: Computer mart moves
computerSmartMove()
{
	sign=$1
	computerSmartMoveInRow $sign
	if [[ $flag -eq 0 ]]
	then
		computerSmartMoveInColumn $sign
	fi
	if [[ $flag -eq 0 ]]
	then
		computerSmartMoveInDiagonal $sign
	fi
}
#computerMove: Computer Moves
computerMove()
{
	flag=0
	computerSmartMove $computerTurn
	if [[ $flag -eq 0 ]]
	then
		computerSmartMove $opponentTurn
	fi
	if [[ $flag -eq 0 ]]
	then
		computerCorner
	fi
	if [[ $flag -eq 0 ]]
	then
		computerCentre
	fi
	if [[ $flag -eq 0 ]]
	then
		computerSide
	fi
}
#opponentMove: User Moves
opponentMove()
{
	echo "Your Move"
	read position
	row=$(( $position / 10 ))
	column=$(( $position % 10))
	inputBoard
}
#startGame: Run until one of the player will win
startGame()
{
	while (( $choice == 1 ))
	do
		initialize 0 0
		((++count))
		echo "===player turn : $currentPlayerTurn===="
		if (( $currentPlayerTurn == $opponentTurn ))
		then
			opponentMove
		fi
		if (( $currentPlayerTurn == $computerTurn ))
		then
			echo "Computer Move"
			computerMove
		fi
	done
}
#freshStart: Initial conditions
freshStart()
{
	resetBoard
	assignLetter
}
freshStart
displayBoard
startGame



