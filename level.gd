extends Control


@onready var player = $Player
@onready var camera = $Player/Camera2D

func _ready():
	player.set_physics_process(false)
	run_dialogue()
	pass

func run_dialogue():
	# open file and parse for text
	# fade in textbox
	# fade out textbox
	player.set_physics_process(true)


func _process(_delta):
	var camera_pos = camera.get_target_position()
	if camera_pos.x < 576:
		camera.position.x = 395
		camera.enabled = false
	if player.position.x > 0:
		print("enable camera")
		camera.position.x = 0
		camera.position.y = -31
		camera.enabled = true
