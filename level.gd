extends Control


@onready var player = $Player
@onready var camera = $Camera2D

func _ready():
	player.set_physics_process(false)
	run_dialogue()
	pass

func run_dialogue():
	# open file and parse for text
	# fade in textbox
	# fade out textbox
	player.set_physics_process(true)

func reset_game():
	player.global_position = player.origin

func _process(_delta):
	camera.position.x = player.position.x
	if player.global_position.y > 700:
		reset_game()
