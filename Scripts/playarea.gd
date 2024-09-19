extends Area2D

@onready var path_follow_2d: PathFollow2D = $"../LittleGuy/Path2D/PathFollow2D"

func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if not bodies.has(enemy):
			enemy.visible = false
			path_follow_2d.progress_ratio = randf()
			enemy.global_position = path_follow_2d.global_position
		else:	
			enemy.visible = true
