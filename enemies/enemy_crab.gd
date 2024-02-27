extends CharacterBody2D

@export var partrol_point : Node
@export var Speed : int = 1500
@export var wait_time : float = 3

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer

const GRAVITY = 1000

enum State { Idle, Walk }
var current_state : State
var direction: Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var can_walk : bool

func _ready():
	if partrol_point != null:
		number_of_points = partrol_point.get_children().size()
		for point in partrol_point.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No patrol points")
	
	current_state = State.Idle
	timer.wait_time = wait_time
	
	
func _physics_process(delta: float):
	eneny_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()
	
	enrmy_animation()

func eneny_gravity(delta: float):
	velocity.y += GRAVITY * delta
	
func enemy_idle(delta: float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, Speed * delta)
		current_state = State.Idle
	
func enemy_walk(delta: float):
	if !can_walk:
		return
	
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * Speed * delta
		current_state = State.Walk
	else:
		current_point_position += 1
	
		if current_point_position >= number_of_points:
			current_point_position = 0
		
		current_point = point_positions[current_point_position]
	
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		can_walk = false
		timer.start()

	animated_sprite_2d.flip_h = direction.x > 0

func enrmy_animation():
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("walk")

func _on_timer_timeout():
	can_walk = true

