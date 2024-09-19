extends Node2D

@onready var options = preload("res://Scenes/options.tscn")
var in_options = false
var options_instance = null

func _process(delta: float) -> void:
	if in_options == true:
		if Input.is_action_just_pressed("escape"):
			in_options == false
			options_instance.queue_free()
			options_instance = null

func _on_quitbutton_pressed() -> void:
	get_tree().quit()

func _on_options_button_pressed() -> void:
	options_instance = options.instantiate()
	add_child(options_instance)
	in_options = true

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
