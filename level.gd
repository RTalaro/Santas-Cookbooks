extends Control

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var counter = $GUI/Counter
@onready var textbox = $GUI/Textbox
@onready var text = $GUI/Textbox/InnerRect/Text
@onready var player = $Player
@onready var santa = $Santa
@onready var santa_sprite = $Santa/Sprite2D
@onready var camera = $Camera2D
@onready var window = $Window

@export var last_checkpoint = 0
@export var num_cookbooks = 0
@export var all_cookbooks = [false, false, false, false, false, false, false]

signal proceed_text
signal cookbook_collected
signal quest_complete

func _ready():
	player.set_physics_process(false)
	counter.text = "Find Santa's Cookbooks! %d/7" % num_cookbooks
	text.text = ""
	await run_dialogue("start")
	player.set_physics_process(true)
	cookbook_collected.connect(on_cookbook_collected)
	quest_complete.connect(end_game)

func run_dialogue(file_name: String):
	var dialogue_path = "res://dialogue/%s.txt" % file_name
	var dialogue = FileAccess.open(dialogue_path, FileAccess.READ)
	
	animation_player.play("santa_fade_in")
	await animation_player.animation_finished
	var line = dialogue.get_line()
	while not dialogue.eof_reached():
		animation_player.play("santa_hat_bounce")
		text.visible_characters = 5
		text.text = "Santa: " + line
		while text.visible_characters < len(text.text):
			timer.start(0.04)
			await timer.timeout
			text.visible_characters += 1
		await proceed_text
		line = dialogue.get_line()
	text.text = ""
	animation_player.play("santa_fade_out")
	await animation_player.animation_finished

func jump_to_checkpoint(checkpoint_num: int):
	print("jump to checkpoint ", checkpoint_num)

func reset_game():
	# TO-DO: reset player position to closest checkpoint behind
	player.global_position = player.origin

func on_cookbook_collected(book_num: int):
	num_cookbooks += 1
	counter.text = "Find Santa's Cookbooks! %d/7" % num_cookbooks
	all_cookbooks[book_num - 1] = true
	var child_name = "Cookbook%d" % book_num
	var child_node = get_node(child_name)
	call_deferred("remove_child", child_node)
	print(all_cookbooks)
	if all_cookbooks.find(false) < 0:
		counter.text = "Return to Santa's Window!"

func end_game():
	player.set_physics_process(false)
	await run_dialogue("end")
	# TO-DO: run credits here
	print("game complete!")

func _process(_delta):
	if textbox.modulate == Color(1.0,1.0,1.0,1.0) and Input.is_action_just_pressed("proceed_text"):
		proceed_text.emit()
	
	camera.position.x = player.position.x
	if player.global_position.y > 700:
		reset_game()
