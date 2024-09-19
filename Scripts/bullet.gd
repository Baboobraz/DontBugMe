extends CharacterBody2D

@onready var timer = $bullettimer

const SPEED = 300
var local_target 
var direction

func on_instantiate(mouth, target):
	global_position = mouth
	local_target = target.global_position
	direction = (local_target - global_position).normalized()

func _process(delta: float) -> void:
	velocity = direction * SPEED
		
	move_and_slide()
		
	if global_position == local_target:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free()


func _on_bullettimer_timeout() -> void:
	queue_free()
