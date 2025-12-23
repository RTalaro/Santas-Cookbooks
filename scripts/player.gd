extends CharacterBody2D

@export var speed = 500
@export var gravity = 40
@export var jump_force = 500

@onready var sprite = $Sprite2D

var origin: Vector2

func _ready():
	origin = global_position

func _physics_process(_delta):
	if !is_on_floor() and velocity.y < 500:
		velocity.y += gravity
	
	elif is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
	
	var horizontal_dir = Input.get_axis("move_left", "move_right")
	match horizontal_dir:
		-1.0:
			sprite.flip_h = true
		1.0:
			sprite.flip_h = false
	velocity.x = speed * horizontal_dir
	move_and_slide()
