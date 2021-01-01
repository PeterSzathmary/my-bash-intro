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
	# Get user name.
	echo -ne "And who might you be? -> ${cl_red}"
	read name

	# Printing it to the terminal.
	echo -e "${cl_reset}Hello -> ${cl_green}$name${cl_reset} <-"
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
		# Print favorite number.
		echo "Your favorite number is: $favorite_number"

		echo "Simple Math with number $favorite_number"
		# Do a little math with that number.
		# Call function do_math() with one argument.
		do_math $favorite_number
	fi
}

# Do simple math operations + - * /
function do_math() {
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
		echo -ne "$((n1/n2))\t${cl_blue}remainder: $((n1%n2))${cl_reset}"
	fi

}

# Calling main function.
main