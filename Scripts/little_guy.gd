extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 1500
const FRICTION = 1200

const MAX_HEALTH = 10
var health = 0

var last_facing_direction = Vector2.DOWN

@onready var axis = Vector2.ZERO
@onready var health_bar = $HealthBar
@onready var animated_sprite = $Sprite2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_invincible = false

func _ready() -> void:
	health = MAX_HEALTH
	health_bar.value = health
	health_bar.max_value = MAX_HEALTH

func _physics_process(delta: float) -> void:
	axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
		animated_sprite.play("idle")
	else:
		apply_movement(axis * ACCELERATION * delta)
		animated_sprite.play("walk")
		last_facing_direction = axis.normalized()
	
	# Update sprite visibility based on the last facing direction
	if last_facing_direction.y < 0:
		animated_sprite.visible = false
	else:
		animated_sprite.visible = true
		
		
	move_and_slide()

func get_input_axis():
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()
	
func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		
func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(SPEED)
	
func take_damage(amount):
	if visible == false:
		return
	elif is_invincible == true:
		return
	else:
		is_invincible = true
		animation_player.play("hurt")
		health -= amount
		health_bar.value = health
		if health <= 0:
			visible = false
			Globals.is_dead = true
		else:
			audio_player.play()
		await animation_player.is_playing()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		animation_player.play("invincible")
	elif anim_name == "invincible":
		is_invincible = false
