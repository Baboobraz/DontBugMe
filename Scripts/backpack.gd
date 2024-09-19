extends StaticBody2D

var id_of_selected = 0
var selector_nodes
var can_build = true

@export var backpack_resources:Array[backpackresource]
@onready var build_timeout: Timer = $BuildTimeout

func _ready() -> void:
	find_selector_nodes()
	for node in selector_nodes:
		node.visible = false	
	
func _process(delta: float) -> void:
	find_selector_nodes()
	
	id_of_selected = Globals.build_cur_id
	
	if Input.is_action_just_pressed("e"):
		if Globals.is_in_shop == true:
			Globals.is_in_shop = false
		else:
			Globals.is_in_shop = true
			
		if Globals.is_in_shop == true:
			for node in selector_nodes:
				node.visible = true
		else:
			for node in selector_nodes:
				node.visible = false
	
	if Globals.is_in_shop == false:
		return

						
func find_selector_nodes():
	if selector_nodes != null:
		selector_nodes.clear()
	selector_nodes = get_tree().get_nodes_in_group("selector")

	for i in range(selector_nodes.size()):
		var node = selector_nodes[i]
		if not node.is_connected("clicked", Callable(self, "build_item")):
			node.connect("clicked", Callable(self, "build_item").bind(i))

func build_item(pos: Vector2, node, rot, index):
	if id_of_selected == -1:
		return
	elif Globals.cur_money >= backpack_resources[id_of_selected].cost:
		if can_build == true:
			can_build = false
			build_timeout.start()
			Globals.cur_money -= backpack_resources[id_of_selected].cost
			if backpack_resources[id_of_selected].has_one == true:
				backpack_resources[id_of_selected].cost += backpack_resources[id_of_selected].increase_to_cost
			else:
				backpack_resources[id_of_selected].has_one = true
				backpack_resources[id_of_selected].cost += backpack_resources[id_of_selected].start_cost_increase
			var item = backpack_resources[id_of_selected].scene.instantiate()
			add_child(item)
			move_child(item, 0)
			var selected_node = pos
			if selected_node:
				item.global_position = selected_node
				item.global_rotation = node.global_rotation

				node.queue_free()
			else:
				return


func _on_build_timeout_timeout() -> void:
	can_build = true
