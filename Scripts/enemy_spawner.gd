extends Node

@export var enemies:Array[PackedScene]
@export var enemy_resources:Array[enemyresource]
@export var timers:Array[Timer]
@onready var path = $"../LittleGuy/Path2D/PathFollow2D"


func _ready() -> void:
	for i in range(timers.size()):
		timers[i].connect("timeout", Callable(self, "on_timer_timeout").bind(i))
		timers[i].wait_time = enemy_resources[i].spawn_start_time
		timers[i].start()

func spawn_enemy(id):
	if Globals.cur_enemies >= 300:
		return
	elif enemy_resources[id].can_spawn == false:
		return
	else:
		Globals.cur_enemies += 1
		path.progress_ratio = randf()
		var enemy = enemies[id].instantiate()
		add_child(enemy)
		enemy.global_position = path.global_position

func calculate_wait_time(id):
	var prev_id = (id - 1)
	
	if enemy_resources[id].first_spawn == false:
		enemy_resources[id].first_spawn = true
		timers[id].wait_time -= enemy_resources[id].time_depleted_at_first_spawn
		return
	
	elif (timers[id].wait_time - enemy_resources[id].time_depleted) <= 0:
		timers[id].wait_time = enemy_resources[id].spawn_min_time
		disable_prev_enemy(prev_id)
	else:	
		timers[id].wait_time -= enemy_resources[id].time_depleted
		if timers[id].wait_time <= enemy_resources[id].spawn_min_time:
			timers[id].wait_time = enemy_resources[id].spawn_min_time
			disable_prev_enemy(prev_id)
		else:
			enemy_resources[id].time_depleted += enemy_resources[id].depletion_added
	if id == 2:
		print("Wait time for wasp: ", timers[id].wait_time)
func on_timer_timeout(timer_index):
	spawn_enemy(timer_index)
	calculate_wait_time(timer_index)

func disable_prev_enemy(id):
	if enemies.size() < (id + 1):
		return
	elif enemy_resources[id].can_spawn == true and id != -1:
		print("DISABLING ID: ", id)
		enemy_resources[id].can_spawn = false
