extends Panel

@export var slots: Array[Panel]
@export var items: Array[backpackresource]

var cost_texts: Array[Label]
var last_slot_selected = null
var cost_string: String = "Cost: $"

func _process(delta: float) -> void:
	if Globals.is_in_shop == false:
		Globals.build_cur_id = -1
		if last_slot_selected == null:
			return
		else:
			var color = slots[last_slot_selected].self_modulate
			slots[last_slot_selected].self_modulate = Color(color.r8, color.g8, color.b8, 0)
			last_slot_selected = null
	for i in range (cost_texts.size()):
		var ctext = str(items[i].cost)
		cost_texts[i].text = (cost_string + ctext)

func _ready() -> void:
	for i in range(slots.size()):
		var button = slots[i].get_child(0).get_child(0)
		var name_text = slots[i].get_child(0).get_child(2)
		name_text.text = items[i].name
		cost_texts.append(slots[i].get_child(0).get_child(3))
		var ctext = str(items[i].cost)
		cost_texts[i].text = (cost_string + ctext)
		if button.has_signal("pressed"):
			button.connect("pressed", Callable(self, "button_pressed").bind(i))
		else:
			print("NOPE")
		var color = slots[i].self_modulate
		slots[i].self_modulate = Color(color.r8, color.g8, color.b8, 0)
		var textrect = slots[i].get_child(0).get_child(1)
		textrect.texture = items[i].texture
		
func button_pressed(id: int) -> void:
	Globals.build_cur_id = id
	if last_slot_selected != null:
		var prev_color = slots[last_slot_selected].self_modulate
		slots[last_slot_selected].self_modulate = Color(prev_color.r, prev_color.g, prev_color.b, 0)
	
	var color = slots[id].self_modulate
	slots[id].self_modulate = Color(color.r, color.g, color.b, 1)
	
	last_slot_selected = id
