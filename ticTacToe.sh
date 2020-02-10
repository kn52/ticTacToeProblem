#!/bin/bash
readonly ROWS=3
readonly COLUMNS=3
readonly EMPTY=5
declare -A board
count=0
choice=1
playerTurn=1
moves=0
boolean=5
position=-1
echo "Welcome to Tic Tac Toe Problem"
#initialize
initialize()
{
	x=0
	y=0
}
#resetGame: To initialize board or for fresh start 
resetGame()
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
	echo
}
#letterAssign: To assign letter X or O
letterAssign()
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
	if (( $boolean == 1 && $playerTurn == $computerTurn ))
	then
		echo "Computer wins...!!"
		choice=0
		exit
	elif (( $boolean == 1 && $playerTurn == $opponentTurn))
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
	if (( $playerTurn == 1 ))
	then
		playerTurn=2
	else
		playerTurn=1
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
		changeTurn
	else 
		echo "Board is Occupied"
	fi
}
#computerSmartMoveInRow
computerSmartMoveInRow()
{
	flag=0
	letter=$1
	for ((i=0;i<$ROWS;i++))
	do
		j=0
		if (( ${board[$i,$j]} == $letter && ${board[$i,$((j+1))]} == $letter && ${board[$i,$((j+2))]} == $EMPTY ))	
		then 
			x=$i 
			y=$((j+2))
			flag=1
			input
			break
		fi
		if (( ${board[$i,$j]} == $EMPTY && ${board[$i,$((j+1))]} == $letter && ${board[$i,$((j+2))]} == $letter ))	
		then
			x=$i 
			y=$j
			flag=1 
			input
			break
		fi
		if (( ${board[$i,$j]} == $letter && ${board[$i,$((j+1))]} == $EMPTY && ${board[$i,$((j+2))]} == $letter ))	
		then 
			x=$i 
			y=$((j+1))
			flag=1
			input
			break
		fi
	done
}
#computerSmartMoveInColumn
computerSmartMoveInColumn()
{
	flag=0
	letter=$1
	for ((i=0;i<$ROWS;i++))
	do
		j=0
		if (( ${board[$j,$i]} == $letter && ${board[$((j+1)),$i]} == $letter && ${board[$((j+2)),$i]} == $EMPTY ))	
		then 
			x=$((j+2)) 
			y=$i
			flag=1
			input
			break
		fi
		if (( ${board[$j,$i]} == $EMPTY && ${board[$((j+1)),$i]} == $letter && ${board[$((j+2)),$i]} == $letter ))	
		then 
			x=$j 
			y=$i
			flag=1			
			input
			break
		fi
		if (( ${board[$j,$i]} == $letter && ${board[$((j+1)),$i]} == $EMPTY && ${board[$((j+2)),$i]} == $letter ))	
		then 
			x=$((j+1)) 
			y=$i
			flag=1
			input
			break
		fi
	done
}
#computerSmartMoveInDiagonal
computerSmartMoveInDiagonal()
{
	flag=0
	letter=$1
	if (( ${board[0,0]} == $letter && ${board[1,1]} == $letter && ${board[2,2]} == $EMPTY ))
	then
		x=2
		y=2
		flag=1
		input
	fi 
	if (( ${board[0,0]} == $letter && ${board[1,1]} == $EMPTY && ${board[2,2]} == $letter ))
	then 
		x=1
		y=1
		flag=1
		input
	fi
	if (( ${board[0,0]} == $EMPTY && ${board[1,1]} == $letter && ${board[2,2]} == $letter ))
	then 
		x=0
		y=0
		flag=1
		input
	fi
	if (( ${board[2,0]} == $letter && ${board[1,1]} == $letter && ${board[0,2]} == $EMPTY ))
	then 
		x=0
		y=2
		flag=1
		input
	fi
	if (( ${board[2,0]} == $letter && ${board[1,1]} == $EMPTY && ${board[0,2]} == $letter ))
	then 
		x=1
		y=1
		flag=1
		input
	fi
	if (( ${board[2,0]} == $EMPTY if [[ $x -eq 0 && $y -eq 0 ]]
	then
		computerCentre
	fi&& ${board[1,1]} == $letter && ${board[0,2]} == $letter ))
	then 
		x=2
		y=0
		flag=1
		input
	fi
}
#computerCorner
computerCorner()
{
	for (( i=0;i<$ROWS;i=$((i+2)) ))
	do
		for (( j=0;j<$COLUMNS;j=$((j+2)) ))
		do
			if (( ${board[$i,$j]} == 5 ))
			then
				x=$i 
				y=$j
				break
			fi
		done
	done
	input
}
#computerCentre
computerCentre()
{
	if (( ${board[1,1]} == 5 ))
	then
		x=1 
		y=1
	fi
	input
}
#computerSide
computerSide()
{
	key=0
	flag=0
	for (( i=0 ;i<$ROWS;i++ ))
	do
		if (( $key == 0 ))
		then
			if (( ${board[$i,$((key+1))]} == $computerTurn ))
			then
				x=$i
				y=$(($key+1))
				flag=1
			fi
			key=1
		else
			for ((j=0;j<$COLUMNS;j=j+2))
			do
				if (( ${board[$i,$((j+2))]} == $computerTurn ))
				then
					x=$i
					y=$((j+2))
					flag=1
				fi
			done
			key=0
		fi
		if (( $flag == 1 ))
		then
			break
		fi
	done
	input		
}

#computerSmartMove
computerSmartMove()
{
	sign=$1
	computerSmartMoveInRow $sign
	if [[ $flag -eq 0 ]]
	then
		computerSmartMoveInColumn $sign
	elif [[ $flag -eq 0 ]]
	then
		computerSmartMoveInDiagonal $sign
	fi	
}
#computerMove
computerMove()
{	
	if [[ $x -eq 0 && $y -eq 0 ]]
	then
		computerSmartMove $computerTurn
	fi	
	if [[ $x -eq 0 && $y -eq 0 ]]
	then
		computerSmartMove $opponentTurn	
	fi
	if [[ $x -eq 0 && $y -eq 0 ]]
	then
		computerCorner
	fi
	if [[ $x -eq 0 && $y -eq 0 ]]
	then
		computerCentre
	fi
	if [[ $x -eq 0 && $y -eq 0 ]]
	then
		computerSide
	fi
}
#opponentMove
opponentMove()
{
	echo "Enter Your Move:"
	read position
	x=$(($position/10)) 
	y=$(($position%10))
	echo "Your Move"
	input 
}
#ticTacToe: Game
ticTacToe()
{
	while (( $choice == 1 ))
	do
		initialize
		((++count))
		if (( $playerTurn == $opponentTurn ))
		then
			opponentMove			
		elif (( $playerTurn == $computerTurn ))
		then				
			echo "Computer Move"
			if [[ $count -eq 1 ]]
			then
				computerCorner
			else			
				computerMove			
			fi			
		fi
	done
}
#startGame: Initial conditions  
startGame()
{
	resetGame
	letterAssign
}
startGame
displayBoard
ticTacToe
