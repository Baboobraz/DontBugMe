extends StaticBody2D

var has_target = true
var can_attack = true

@onready var cooldown: Timer = $cooldown
@onready var area: Area2D = $Area2D

func _process(delta: float) -> void:
	if has_target:
		if can_attack:
			cooldown.start()
			can_attack = false
			var bodies = area.get_overlapping_bodies()
			for body in bodies:
				if body.is_in_group("enemy"):
					if body.has_method("take_damage"):
						body.take_damage(2, "Spray")
					else:
						print("no")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		has_target = true

func _on_cooldown_timeout() -> void:
	can_attack = true
