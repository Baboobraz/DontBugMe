extends Node2D

@onready var gameover: CanvasLayer = $pause
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var death_sound_heard = false

func _process(delta: float) -> void:
	if Globals.is_dead == true:
		Globals.is_paused = true
		if death_sound_heard == false:
			death_sound_heard = true
			audio_stream_player.play()
	if Globals.is_paused == false:
		gameover.visible = false
		get_tree().paused = false
	elif Globals.is_paused == true:
		Globals.is_in_shop = false
		gameover.visible = true
		get_tree().paused = true
