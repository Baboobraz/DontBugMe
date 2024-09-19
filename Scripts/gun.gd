extends StaticBody2D

var target
@onready var timer = $cooldown
@onready var area = $Area2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

var can_fire = true

func _physics_process(delta: float) -> void:
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			target = body
			break
	
	if can_fire == true and target != null:
		can_fire = false
		if target.has_method("take_damage"):
			target.take_damage(1, "Swatter")
		animation_player.play("swat")
		timer.start()
		audio_stream_player.play()

func _on_cooldown_timeout() -> void:
	can_fire = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
