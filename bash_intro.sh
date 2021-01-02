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
	display_menu
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
			3) tic_tac_toe ;;
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

	echo -e "${cl_green}=== Tic-Tac-Toe Game ===${cl_reset}"

	######################
	#                    #
	#     Variables      #
	#                    #
	######################

	# Size of the board.
	boardSize=5

	# Declare a new array "board".
	declare -A board

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
			board[$i]="0"
		done
	}

	# Display board.
	function display_board() {
		
		for ((i=1; i<boardSize*boardSize+1; i++))
		do
			# If we are on the beginnig of every line.
			if [[ $(($((i-1)) % $boardSize)) -eq 0 ]]
			then
				echo -n "| "
			fi

			# Print cell value at index "i".
			echo -n "_${board[$((i-1))]}_"
			echo -n " | "

			# If we are at the end of every line.
			if [[ $(($i % $boardSize)) -eq 0 ]]
			then
				#echo "$i is divisible by $boardSize"

				# Go on the new line.
				echo
			fi
		done
	}

	create_board
	display_board

	
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
#main
tic_tac_toe