extends Sprite2D

@export var is_horizontal = false
@export var is_left = false

signal clicked(pos, node)
var mouse_entered = false

func _process(delta: float) -> void:
	if mouse_entered == true:
		if Input.is_action_just_pressed("left_click"):
			clicked.emit(global_position, self, get_parent().global_rotation)

func _on_static_body_2d_mouse_entered() -> void:
	mouse_entered = true

func _on_static_body_2d_mouse_exited() -> void:
	mouse_entered = false
