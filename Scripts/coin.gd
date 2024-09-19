extends StaticBody2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var bounce_time = 0.5  # Duration of the bounce effect
var bounce_amplitude = 200.0  # How high the object bounces
var bounce_speed = 20.0  # How fast the bounce oscillates
var bounce_elapsed_time = 0.0  # To track the time since the bounce started
var bounce_active = true

var x_random

var global_id = -1
var queued = false

func _ready() -> void:
	bounce_active = true
	bounce_elapsed_time = 0.0
	x_random = randf_range(-70, 70)
	
	# Append to the arrays
	Globals.coins.append(self)
	Globals.coin_visible.append(true)
	
	# Set global_id to the index of the newly added coin
	global_id = Globals.coins.find(self)

func _process(delta: float) -> void:
	if bounce_active:
		if bounce_elapsed_time < bounce_time:
			var bounce_offset = bounce_amplitude * sin(bounce_speed * bounce_elapsed_time)
			global_position.y += bounce_offset * delta
			bounce_elapsed_time += delta
			global_position.x += x_random * delta
		else:
			bounce_active = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if queued == true:
			return
		else:
			queued = true
			visible = false
			Globals.cur_money += 1
			Globals.cur_coins -= 1
			Globals.coins.erase(self)
			Globals.coin_visible.erase(global_id)  # Ensure you remove visibility state
			audio_player.play()
			await audio_player.finished
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if global_id >= 0 and global_id < Globals.coin_visible.size():
		Globals.coin_visible[global_id] = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if global_id >= 0 and global_id < Globals.coin_visible.size():
		Globals.coin_visible[global_id] = true
