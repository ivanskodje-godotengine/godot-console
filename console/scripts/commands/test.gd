extends "../command.gd"

func _init():
	name = "test" # Set command name
	

# Perform command
func perform_action(input):
	# This is where you write the code for handling any extra arguments after the command name
	# ..
	
	# Returns output to console
	return "Test: " + str(input)
