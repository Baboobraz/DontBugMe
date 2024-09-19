extends Control

@onready var money_text = $money
@onready var build_menu: Panel = $"../Control2/BuildMenu"
@onready var time: Label = $"../Control3/gametime/time"

var seconds = 0

func _process(delta: float) -> void:
	money_text.text = str(Globals.cur_money)
	if Globals.is_in_shop == false:
		build_menu.visible = false
	else:
		build_menu.visible = true
	

func _on_button_pressed() -> void:
	print("PRESSED")


func _on_timer_timeout() -> void:
	seconds += 1
	var minutes = seconds / 60
	var display_seconds = seconds % 60
	time.text = str(minutes).pad_zeros(2) + ":" + str(display_seconds).pad_zeros(2)
