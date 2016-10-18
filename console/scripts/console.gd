extends CanvasLayer

# Paths to nodes
var path_to_rich_text_panel = "control/panel/rich_text_label"
var path_to_line_edit = "control/panel/line_edit"
var path_to_animation_player = "control/animation_player"

# Nodes
onready var rich_text_panel_node = get_node(path_to_rich_text_panel)
onready var line_edit_node = get_node(path_to_line_edit)
onready var animation_player_node = get_node(path_to_animation_player)

# Command List
const CommandList = preload("command_list.gd")
onready var command_list = CommandList.new(self)

# Key Input : Enter the keymap values!
export (String) var input_map_enter
export (String) var input_map_toggle

# Console status
var is_enabled = false

# Console signal
signal console


func _ready():
	# Setup processes
	set_process(false)
	set_process_input(true)
	
	# Add indentation and scrolling so you always see bottom line
	rich_text_panel_node.push_indent(1)
	rich_text_panel_node.set_scroll_follow(true)


func _process(delta):
	# Prevents removal of command line sign "$ " 
	if(line_edit_node.get_text().length() <= 1):
		clear()
	
	# Enable focus after animation has been completed and enabled
	if(!animation_player_node.is_playing() && is_enabled):
		line_edit_node.set_focus_mode(line_edit_node.FOCUS_CLICK)
		line_edit_node.grab_focus()


func _input(event):
	# Processes user input in console
	if(is_enabled):
		if(event.is_action_pressed(input_map_enter)):
			process_command(line_edit_node.get_text())
	# Toggle console
	if(event.is_action_pressed(input_map_toggle)):
		toggle()


func process_command(msg):
	# Write input to console
	write(msg)
	
	# Clean the string
	msg = msg.replace("$ ", "")
	msg = msg.strip_edges()
	
	# Run the command if it's not empty
	if(msg != ""):
		var returned_msg = command_list.execute(msg)
		
		if(returned_msg != ""):
			write(returned_msg)


# Writes to console
func write(msg):
	rich_text_panel_node.add_text(str(msg) + "\n")
	clear()


# Execute command directly from outside (without interacting with console directly)'
# Usually used to toggle something on and off via console (so that it knows what is going on)
func execute(cmd):
	command_list.execute(cmd)


# Clears the command line
func clear():
	line_edit_node.set_text("$ ")
	line_edit_node.set_cursor_pos(2)


# Toggles the console window
func toggle():
	if(!animation_player_node.is_playing()): 
		is_enabled = !is_enabled
		set_process(is_enabled)
		
		# Remove line edit focus when disabling console
		if(!is_enabled):
			line_edit_node.set_focus_mode(line_edit_node.FOCUS_NONE)
			line_edit_node.grab_focus()
		
		# Animation
		if(is_enabled):
			animation_player_node.play("open_console")
		else:
			animation_player_node.play("close_console")
		
		# Notify others
		notify_others()


# Notifies other scripts that are connected to this, that console status has changed
func notify_others():
	emit_signal("console_status", is_enabled)
