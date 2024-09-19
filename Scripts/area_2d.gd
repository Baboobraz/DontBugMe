extends Area2D

@onready var path: PathFollow2D = $"../Path2D/PathFollow2D"

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		path.progress_ratio = randf()
		body.global_position = path.global_position
