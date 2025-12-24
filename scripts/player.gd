extends CharacterBody2D

var can_coyote_jump = false
@export var speed = 500
@export var gravity = 40
@export var jump_force = 500

@onready var sprite = $Sprite2D
@onready var jump_sfx = $JumpSFX
@onready var coyote_timer = $CoyoteTimer

var origin: Vector2

func _ready():
	coyote_timer.timeout.connect(on_coyote_timer_timeout)
	origin = global_position

func _physics_process(_delta):
	if !is_on_floor() and !can_coyote_jump:
		velocity.y += gravity
		if velocity.y > 500:
			velocity.y = 500
	
	elif Input.is_action_just_pressed("jump"):
		if is_on_floor() || can_coyote_jump:
			jump_sfx.play(0.17)
			velocity.y = -jump_force
			if can_coyote_jump: can_coyote_jump = false
	
	var horizontal_dir = Input.get_axis("move_left", "move_right")
	match horizontal_dir:
		-1.0:
			sprite.flip_h = true
		1.0:
			sprite.flip_h = false
	velocity.x = speed * horizontal_dir
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor and !is_on_floor() and velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start(0.1)

func on_coyote_timer_timeout():
	can_coyote_jump = false
	
