extends Reference

var name # Command name


# Returns true of input matches name
func matches(input):
	# Split up the string
	var input_name = input
	input_name = input_name.split(" ", true)
	
	# Check if command matches (case insensitive)
	return input_name[0].matchn(name)


# Check if the command is valid; returns an error if it is not valid
func execute(input):
	# Remove the command part of the input
	var raw_input = input
	input = input.replace(name, "") # Remove the command name from the string
	input = input.strip_edges() # Remove any leading or ending whitespace
	return perform_action(input)


# This is overwritten; do not edit here
func perform_action(input):
	pass
