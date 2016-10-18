extends Reference

# All Commands
var commands = []
var node_root # Reference to root node


# Init
func _init(node):
	node_root = node
	load_commands()


# Find command and execute it
func execute(input):
	
	# Get command name from input
	var temp = input
	temp = temp.split(" ", true)
	var command_name = temp[0]
	
	# Get remaining variables from input (if any)
	var vars = ""
	for i in range(1, temp.size()):
		vars += temp[i] + " "
	
	print("<" + str(vars) + ">")
	
	# Iterate commands and execute appropriate command (if any)
	if(commands.size() != 0):
		for cmd in commands:
			if(cmd.matches(command_name)):
				return cmd.execute(input) # Return result message (if any)
		return "Unknown command \"" + str(input) + "\""
	else:
		# Error
		return("No console commands exist")


# Load all commands in /commands/ directory
func load_commands():
	# Get path to /commands/ folder
	var dir = self.get_script().get_path()
	dir = str(dir).replace("command_list.gd", "commands/")
	
	# Load each command
	var directory = Directory.new()
	
	# If we can open directory, load all commands and add to array
	if (directory.open(dir) == OK):
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		while(file_name != ""):
			if (!directory.current_is_dir()):
				commands.append(load(dir + file_name).new())
			file_name = directory.get_next()
		
		directory.list_dir_end()
	else:
		# Error
		print("Command directory \"", dir, "\" could not be opened")
