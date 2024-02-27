extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

@export var gravity : int = 1000
@export var speed : int = 1000
@export var max_horizontal_speed: int = 300
@export var slow_down_speed : int = 1700

@export var jump : int = -300
@export var horizontal_jump_speed : int = 1000
@export var max_horizontal_jump_speed : int = 300

enum State { Idle, Run, Jump }
var current_state : State
var character_sprite : Sprite2D

func _ready():
	current_state = State.Idle
	pass
	
func _physics_process(delta : float):
	
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	
	player_animation()
	
	print("State: ", State.keys()[current_state])
	
func player_falling(delta : float):
	if !is_on_floor():
		velocity.y += gravity * delta

func player_idle(delta : float):
	if is_on_floor():
		current_state = State.Idle
		
func player_run(delta : float):
	if !is_on_floor():
		return
	
	var direction = input_movement()
	if direction:
		velocity.x += direction * speed * delta
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)
	
	if direction != 0:
		current_state = State.Run
		animated_sprite_2d.flip_h = false if direction > 0 else true

func player_jump(delta : float):
	if !is_on_floor():
		return
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump
		current_state = State.Jump
		
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * horizontal_jump_speed * delta
		velocity.x = clamp(velocity.x, -max_horizontal_jump_speed, max_horizontal_jump_speed)

func player_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
		
func input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction
