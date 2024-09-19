extends CanvasLayer

@onready var label: Label = $Control/Label
@onready var retry_text: Label = $Control/RETRY/Label
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var options: PackedScene = preload("res://Scenes/options.tscn")

var in_options = false
var options_instance = null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if in_options == true:
			in_options = false
			options_instance.queue_free()
			options_instance = null
			return
		elif Globals.is_paused == true:
			Globals.is_paused = false
		else:
			Globals.is_paused = true

	if Globals.is_dead == false:
		label.visible = false
		retry_text.text = ("Return")
	else:
		animation_player.play()
		label.visible = true
		retry_text.text = ("Retry")
	
func _on_retrybutton_pressed() -> void:
	Globals.is_paused = false
	if Globals.is_dead == true:
		Globals.is_dead = false
		Globals.restart()
		get_tree().reload_current_scene()


func _on_quitbutton_pressed() -> void:
	get_tree().quit()

func _on_button_pressed() -> void:
	Globals.is_paused = false
	Globals.restart()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_options_button_pressed() -> void:
	in_options = true
	options_instance = options.instantiate()
	add_child(options_instance)
