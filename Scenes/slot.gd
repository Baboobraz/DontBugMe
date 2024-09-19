extends Panel

var can_press = false
@onready var button: Button = $Panel/Button

func _process(delta: float) -> void:	
	if can_press == true:
		if Input.is_action_just_pressed("left_click"):
			button.pressed.emit()

func _on_button_mouse_entered() -> void:
	can_press = true

func _on_button_mouse_exited() -> void:
	can_press = false
