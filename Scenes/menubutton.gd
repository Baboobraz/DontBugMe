extends Panel

var can_press = false
@export var button: Button

func _ready() -> void:
	# Connect the mouse entered signal
	button.mouse_entered.connect(_on_button_mouse_entered)
	
	# Connect the mouse exited signal
	button.mouse_exited.connect(_on_button_mouse_exited)

func _process(delta: float) -> void:	
	if can_press:
		if Input.is_action_just_pressed("left_click"):
			button.pressed.emit()

func _on_button_mouse_entered() -> void:
	can_press = true

func _on_button_mouse_exited() -> void:
	can_press = false
