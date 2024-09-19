extends Node

@onready var axis = Vector2.ZERO
var smoothed_axis = Vector2.ZERO
var smoothing_factor = 0.1

func _process(delta: float) -> void:
	# Get the current mouse position
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Update the input axis
	axis = get_input_axis()

	# Smooth the movement
	smoothed_axis = smoothed_axis.lerp(axis, smoothing_factor)

	# Adjust the sensitivity of the mouse movement
	var sensitivity = 40
	
	# Calculate the new mouse position based on the smoothed input and sensitivity
	var movement_vector = smoothed_axis * sensitivity
	var new_mouse_pos = mouse_pos + movement_vector
	
	if axis:
		get_viewport().warp_mouse(new_mouse_pos)

func get_input_axis():
	axis.x = int(Input.is_action_pressed("mouse_right")) - int(Input.is_action_pressed("mouse_left"))
	axis.y = int(Input.is_action_pressed("mouse_down")) - int(Input.is_action_pressed("mouse_up"))
	return axis
