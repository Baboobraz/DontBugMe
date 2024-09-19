extends Resource

class_name enemyresource

@export var name:String
@export var health:int
@export var attack_damage:int
@export var speed:float
@export var gold_dropped:int
@export var cooldown:float
@export var time_depleted:float
@export var depletion_added:float
@export var can_spawn:bool = true
@export var first_spawn:bool = false
@export var time_depleted_at_first_spawn:float
@export var immunities:Array[String]

@export var spawn_start_time:float
@export var spawn_min_time:float
