#!/bin/bash

# Defining some colors for later use.
cl_red="\033[0;31m"
cl_green="\033[0;32m"
cl_blue="\033[0;34m"
cl_cyan="\033[0;36m"

# Reset all to default.
cl_reset="\033[0;0m"

# Create main function.
# It needs to be called last.
function main() {
	bS=$1
	# Victory On
	vO=$2
	display_menu ${bS} ${vO}
}

# Menu.
function display_menu() {

	# Greet the user.
	echo -ne "Welcome back, ${cl_red}${USER^^}${cl_reset}! "
	# Print date.
	echo "Today is: $(date +"%m-%d-%Y")"

	# Infinite loop.
	while true
	do
		echo -e "\nWhat would you like to do now?\n"
		echo "1) do a magic trick"
		echo "2) do math"
		echo "3) Tic-Tac-Toe game"
		echo -e "0) ${cl_red}exit${cl_reset}\n"

		read -n1 -p "Enter now: " option

		clear

		case $option in
			1) do_magic ;;
			2) do_math ;;
			3) tic_tac_toe ${bS} ${vO} ;;
			# Break the while loop.
			0) break ;;
		esac
	done

	echo -e "\n\n${cl_green}Have a nice day!${cl_reset}"
}

# Tic-Tac-Toe game with predefined size.
function tic_tac_toe() {

	# Clear the screen.
	clear	

	######################
	#                    #
	#     Variables      #
	#                    #
	######################

	# Size of the board.
	boardSize=$1

	# Set victory condition.
	victoryOn=$2

	# Which player has won?
	playerWon="-"

	# Declare a new array "board".
	declare -A board

	# Is the game running?
	isRunning=true

	# Players.
	playerX="X"
	playerO="O"

	x=0
	y=0

	# Who is on the move?
	playerTurn=$playerX

	goAgain=false

	#####################
	#                   #
	#     Functions     #
	#                   #
	#####################

	# Create board for the game.
	function create_board() {
		
		for ((i=0; i<boardSize*boardSize; i++))
		do
			# This is working fine...
			#echo "i: $i"

			# Default cell values.
			board[$i]="_"
			#board[$i]=$i
		done
	}

	# Display board.
	function display_board() {
		
		first=true

		# Mark all columns.
		for ((i=1; i<boardSize+1; i++))
		do
			if [[ $first == true ]]
			then
				echo -n "     $i  "
				first=false
			else
				echo -n "   $i  "
			fi
		done

		echo -e "\n"

		# Variable for making rows.
		j=0

		for ((i=1; i<boardSize*boardSize+1; i++))
		do
			# If we are on the beginnig of every line.
			if [[ $(($((i-1)) % $boardSize)) -eq 0 ]]
			then
				echo -n "$((++j)) | "
			fi

			# Print cell value at index "i".
			echo -n " ${board[$((i-1))]} "
			echo -n " | "

			# If we are at the end of every line.
			if [[ $(($i % $boardSize)) -eq 0 ]]
			then
				#echo "$i is divisible by $boardSize"

				# Go on the new line.
				echo -e "\n"
			fi
		done
	}

	function place_char() {
		x=$1
		y=$2

		i=$(((x-1)+boardSize*(y-1)))
		echo -e "\ni: $i"
		cellChar=${board[$i]}
		echo "cellChar: $cellChar"

		if [[ $cellChar == "_" ]]
		then
			goAgain=false

			# If the player X is on the move.
			if [[ $playerTurn == "X" ]]
			then
				# Fill with X.
				board[$i]=$playerTurn
				playerTurn=$playerO
			else
				# Fill with O.
				board[$i]=$playerTurn
				playerTurn=$playerX
			fi
		else
			goAgain=true
		fi
	}

	function player_move() {
		currentPlayer=$1

		if [[ $goAgain == true ]]
		then
			echo "That space is already filled. You are going again."
		fi

		if [[ $currentPlayer == "X" ]]
		then
			echo -e "Player ${cl_red}$currentPlayer${cl_reset}"
			read -n1 -p "X: " x

			echo

			read -n1 -p "Y: " y

			place_char $x $y

			#playerTurn=$playerO

			echo
		else
			echo -e "Player ${cl_red}$currentPlayer${cl_reset}"
			read -n1 -p "X: " x

			echo

			read -n1 -p "Y: " y

			place_char $x $y

			#playerTurn=$playerX

			echo
		fi
	}

	# Check horizontal victory for current player.
	function check_horizontal() {

		# Helper variable.
		# I am using it, because I want to move in 1D array as it was 2D.
		#
		#
		# Or maybe I am totally wrong, but it works. :)
		currentRow=1

		# Loop through all rows.
		for((i=0;i<boardSize*boardSize;i++))
		do
			# Check victory.
			if [[ $victoryOn -eq 3 ]]
			then
				if [[ ${board[$i]} == $currentPlayer && ${board[$((i+1))]} == $currentPlayer && ${board[$((i+2))]} == $currentPlayer ]]
				then
					# Victory message!
					echo -e "${cl_green}Player $currentPlayer has won !!!!${cl_reset}"
					# 0 - true
					return 0
				fi
			elif [[ $victoryOn -eq 4 ]]
			then
				if [[ ${board[$i]} == $currentPlayer && ${board[$((i+1))]} == $currentPlayer && ${board[$((i+2))]} == $currentPlayer && ${board[$((i+3))]} == $currentPlayer ]]
				then
					# Victory message!
					echo -e "${cl_green}Player $currentPlayer has won !!!!${cl_reset}"
					# 0 - true
					return 0
				fi
			elif [[ $victoryOn -eq 5 ]]
			then
				if [[ ${board[$i]} == $currentPlayer && ${board[$((i+1))]} == $currentPlayer && ${board[$((i+2))]} == $currentPlayer && ${board[$((i+3))]} == $currentPlayer && ${board[$((i+4))]} == $currentPlayer ]]
				then
					# Victory message!
					echo -e "${cl_green}Player $currentPlayer has won !!!!${cl_reset}"
					# 0 - true
					return 0
				fi
			fi

			# If the index is at the last possible index in the current row.
			if [[ $i -eq $((boardSize*currentRow-victoryOn)) ]]
			then
				i=$((i+victoryOn-1))
				currentRow=$((currentRow+1))

				# Continue the loop.
				continue
			fi
		done

		# 1 - false
		return 1
	}

	function check_vertical() {
		verticalMaxIndex=$(((boardSize*boardSize-1)-(boardSize*(victoryOn-1)))) # (9*9-1)-(9*(5-1)) = 80 - 36 = 44
		#echo "verticalMaxIndex: $verticalMaxIndex"

		# Loop through all columns.
		for((i=0;i<=$verticalMaxIndex;i++))
		do
			# Check victory.
			if [[ $victoryOn -eq 3 ]]
			then
				if [[ ${board[$((i))]} == $currentPlayer && ${board[$((i+boardSize*1))]} == $currentPlayer && ${board[$((i+boardSize*2))]} == $currentPlayer ]]
				then
					# Victory message!
					echo -e "${cl_green}Player $currentPlayer has won !!!!${cl_reset}"
					# 0 - true
					return 0
				fi
			elif [[ $victoryOn -eq 4 ]]
			then
				if [[ ${board[$((i))]} == $currentPlayer && ${board[$((i+boardSize*1))]} == $currentPlayer && ${board[$((i+boardSize*2))]} == $currentPlayer && ${board[$((i+boardSize*3))]} == $currentPlayer ]]
				then
					# Victory message!
					echo -e "${cl_green}Player $currentPlayer has won !!!!${cl_reset}"
					# 0 - true
					return 0
				fi
			elif [[ $victoryOn -eq 5 ]]
			then
				if [[ ${board[$((i))]} == $currentPlayer && ${board[$((i+boardSize*1))]} == $currentPlayer && ${board[$((i+boardSize*2))]} == $currentPlayer && ${board[$((i+boardSize*3))]} == $currentPlayer && ${board[$((i+boardSize*4))]} == $currentPlayer ]]
				then
					# Victory message!
					echo -e "${cl_green}Player $currentPlayer has won !!!!${cl_reset}"
					# 0 - true
					return 0
				fi
			fi
		done

		# 1 - false
		return 1
	}

	function check_dLeft(){
		verticalMaxIndex=$(((boardSize*boardSize-1)-(boardSize*(victoryOn-1))))
		currentRow=1

		for((i=$((victoryOn-1));i<$verticalMaxIndex;i++))
		do

			# Check victory in left diagonal.
			if [[ ${board[$i]} == $currentPlayer && ${board[$((i+boardSize-1))]} == $currentPlayer && ${board[$((i+boardSize*2-2))]} == $currentPlayer ]]
			then
				# Victory message!
				echo -e "${cl_green}Player $currentPlayer has won !!!!${cl_reset}"
				# 0 - true
				return 0
			fi

			# If the index is at the last possible index in the current row.
			if [[ $i -eq $((boardSize*currentRow-1)) ]]
			then
				i=$((i+victoryOn-1))
				currentRow=$((currentRow+1))

				# Continue the loop.
				continue
			fi
		done

		# 1 - false
		return 1
	}

	function check_dRight() {
		verticalMaxIndex=$(((boardSize*boardSize-1)-(boardSize*(victoryOn-1)-(victoryOn-1)))) # (5*5-1) - 5*(3-1) - (3 - 1) = 24 - 10 - (3 - 1) = 12 
		currentRow=1

		for((i=0;i<$verticalMaxIndex;i++))
		do

			# Check victory in left diagonal.
			if [[ ${board[$i]} == $currentPlayer && ${board[$((i+boardSize+1))]} == $currentPlayer && ${board[$((i+boardSize*2+2))]} == $currentPlayer ]]
			then
				# Victory message!
				echo -e "${cl_green}Player $currentPlayer has won !!!!${cl_reset}"
				# 0 - true
				return 0
			fi

			# If the index is at the last possible index in the current row.
			if [[ $i -eq $((boardSize*currentRow-(victoryOn-1)-1)) ]]
			then
				i=$((i+boardSize-1))
				currentRow=$((currentRow+1))

				# Continue the loop.
				continue
			fi
		done

		# 1 - false
		return 1
	}

	function check_diagonal() {
		if check_dLeft || check_dRight
		then
			return 0
		fi
		return 1
	}

	# Check victory for current player.
	function check_victory() {

		#check_vertical

		if check_horizontal || check_vertical || check_diagonal
		then
			return 0
		else
			return 1
		fi

		#clear
	}

	create_board

	# Game loop.
	while $isRunning
	do
		echo -e "${cl_green}=== Tic-Tac-Toe Game ===${cl_reset}"

		# Alwaus display actual board.
		display_board

		# If one of the players has won, break the loop.
		if check_victory
		then
			echo "Ending game!"
			break
		# Otherwise, continue playing.
		else
			player_move $playerTurn
		fi
		clear
	done
	
}

function do_math() {
	# Asking for favorite number.
	echo -ne "\nWhat is your favorite number? -> "

	# Get user favorite number.
	read favorite_number

	# Regex expression for integers or float numbers.
	re="^[0-9]+([.][0-9]+)?$"

	# Check if the input from the user is a number or not.
	if ! [[ $favorite_number =~ $re ]]
	# If the input was not a number.
	then
		# Print error.
		echo "error: Not a number"
	# If the input was a number (integer or not)
	else
		echo -e "\n\t\t**** Simple Math with number $favorite_number ****\n"
		# Do a little math with that number.
		# Call function do_math() with one argument.
		do_operations $favorite_number
	fi
}

# Do magic.
function do_magic() {
	# Really?
	echo
	read -s -n1 -p "Are you sure? [Y/N]" magic

	# Checking input with case statement.
	case $magic in
		# Is the "magic" variable equal to "y" or "Y"?
		# If so call the function do_magic() with argument "screenfetch".
		y|Y) check_package screenfetch ;;
		# If the input was "n" or "N".
		n|N) echo -e "\nNO MAGIC" ;;
		# If the input was something else.
		*) echo -e "\nWRONG INPUT" ;;
	# Case statement ends with esac keyword.
	esac
}

# Check if the package is installed & if not, install it.
function check_package() {
	# Check if the package is installed.
	# Package is passed as first argument.
	dpkg -s $1 &> /dev/null

	# If the package is installed.
	if [ $? -eq 0 ]
	then
		# Clear the screen and run it.
		clear && $1
	# If the package is NOT installed.
	else
		# Downloads the package lists from the repos.
		sudo apt-get -y update
		# Install package.
		sudo apt-get -y install $1
		clear && $1
	fi
}


# Do simple math operations + - * /
function do_operations() {
	# Create variable "number".
	# Put a value of first argument inside it.
	number=$1

	# Do addition.
	operation "+" $(get_random_number) $number
	# Do subtraction.
	operation "-" $(get_random_number) $number
	# Do multiplication.
	operation "*" $number $(get_random_number)
	# Do division.
	operation "/" $(add $number $(get_random_number)) $(get_random_number)
}

# Add two numbers together and return the sum to caller.
function add() {
	echo $(($1 + $2))
}

# Get random number between 1 and 100, both inclusive and return it to caller.
function get_random_number() {
	echo $((1 + $RANDOM % 100))
}

# Do math operation.
function operation() {
	# Operator to use.
	op=$1
	# First number.
	n1=$2
	# Second number.
	n2=$3

	# Display the equation.
	echo -n "$n1 $op $n2 = "

	# If the operator is +
	if [[ $op == "+" ]]
	then
		echo $((n1+n2))

	# operator is -
	elif [[ $op == "-" ]]
	then
		echo $((n1-n2))

	# operator is *
	elif [[ $op == "*" ]]
	then
		echo $((n1*n2))

	# operator is /
	elif [[ $op == "/" ]]
	then
		echo -e "$((n1/n2))\t${cl_blue}remainder: $((n1%n2))${cl_reset}"
	fi

}

# Calling main function.
#main $1 $2
tic_tac_toe $1 $2