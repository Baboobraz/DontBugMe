extends CharacterBody2D

@export var resource: enemyresource
@export var health_bar: ProgressBar
@export var timer: Timer
@onready var coin = preload("res://Scenes/coin.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

#audio
@onready var hurt: AudioStreamPlayer = $Audio/Hurt
@onready var death: AudioStreamPlayer = $Audio/Death

var player
var can_attack = true
var body_entered = false
var queued = false

var cur_health

func _ready() -> void:
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() == 0:
		print("error0")
	elif nodes.size() > 1:
		print("error1")
	else:
		for node in nodes:
			player = node
	timer.wait_time = resource.cooldown
	cur_health = resource.health
	health_bar.max_value = resource.health
	health_bar.value = cur_health

func _process(delta: float) -> void:
	if player == null:
		return
	else:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * resource.speed

		# Ensure velocity does not exceed the maximum speed
		if velocity.length() > resource.speed:
			velocity = velocity.normalized() * resource.speed

		move_and_slide()

		if velocity.length() > 0:  # If the enemy is moving
			animated_sprite_2d.play("walk")

		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player > 0.5:
			var angle = direction.angle() - PI / 2
			animated_sprite_2d.rotation = angle

	if body_entered == true:
		if can_attack == true:
			player.take_damage(resource.attack_damage)
			can_attack = false
			timer.start()

	if body_entered == true:
		if can_attack == true:
			player.take_damage(resource.attack_damage)
			can_attack = false
			timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if can_attack == true:
		if body.is_in_group("player"):
			body_entered = true

func _on_timer_timeout() -> void:
	can_attack = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body_entered = false

func take_damage(amount, type):
	if queued == true:
		return
	if resource.immunities.has(type):
		return
	else:
		hurt.play()
		animation_player.play("hurt")
		cur_health -= amount
		health_bar.value = cur_health
		if cur_health <= 0:
			queued = true
			Globals.cur_enemies -= 1
			collision_shape_2d.queue_free()
			can_attack = false
			death.play()
			animated_sprite_2d.visible = false
			health_bar.visible = false

			# Limit the number of coins affected to the amount in gold_dropped
			for i in range(resource.gold_dropped):
				if Globals.cur_coins >= 500:
					# Move existing coins if the maximum has been reached
					if i < Globals.coins.size():
						var coin = Globals.coins[i]
						if coin:
							coin.global_position = global_position
							coin.bounce_active = true
							coin.bounce_elapsed_time = 0.0
							Globals.coins.erase(coin)
							Globals.coins.append(coin)
				else:
					# Spawn new coins
					Globals.cur_coins += 1
					var new_coin = coin.instantiate()
					get_tree().current_scene.add_child(new_coin)
					new_coin.global_position = global_position
			
			await death.finished
			queue_free()
