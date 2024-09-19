extends Node

#Options
var music_volume:float = 1
var sfx_volume:float = 1
var master_volume:float = 1

var starting_money = 10

var cur_enemies = 0
var cur_coins = 0

var cur_money:int
var is_in_shop = false
var is_paused = false
var is_dead = false

var build_cur_id = -1

var coins:Array[StaticBody2D]
var coin_visible:Array[bool]

@onready var enemy_resources:Array[enemyresource] = [
	preload("res://Enemies/mosquito.tres"),
	preload("res://Enemies/spider.tres")
]
@onready var backpack_resources:Array[backpackresource] = [
	preload("res://backpackitems/spraybottle.tres"),
	preload("res://backpackitems/swatter.tres")
]
func  _ready() -> void:
	restart()

func restart():
	cur_money = starting_money
	cur_enemies = 0
	cur_coins = 0
	for enemy in enemy_resources:
		enemy.first_spawn = false
		enemy.can_spawn = true
	for item in backpack_resources:
		item.cost = item.start_cost
		item.has_one = false
