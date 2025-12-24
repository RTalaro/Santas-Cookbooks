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

@export var cookbooks_held: int = 0
@export var max_checkpoints: int
@export var max_cookbooks: int
@export var all_checkpoints: Array[Node]
@export var all_cookbooks: Array[Node]

signal proceed_text
signal cookbook_collected
signal quest_complete

func _ready():
	player.set_physics_process(false)
	all_checkpoints = extract_children("Checkpoint")
	max_checkpoints = len(all_checkpoints)
	all_cookbooks = extract_children("Cookbook")
	max_cookbooks = len(all_cookbooks)
	
	counter.text = "Find Santa's Cookbooks! %d/%d" % [cookbooks_held, max_cookbooks]
	text.text = ""
	
	# TO-DO: uncomment when game is done
	#await run_dialogue("start")
	player.set_physics_process(true)
	cookbook_collected.connect(on_cookbook_collected)
	quest_complete.connect(end_game)

func extract_children(node_name: String):
	var children: Array[Node] = get_children()
	children = children.filter(
		func(node):
			if node.name.contains(node_name): return true
	)
	var num = 1
	for child in children:
		child.num = num
		num += 1
	return children

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
	animation_player.play("santa_fade_out")
	await animation_player.animation_finished
	text.text = ""

func get_nearest_checkpoint():
	var checkpoints_reversed = all_checkpoints.duplicate()
	checkpoints_reversed.reverse()
	for checkpoint in checkpoints_reversed:
		if checkpoint.global_position.x > player.global_position.x: continue
		else:
			return checkpoint.num

func jump_to_checkpoint(num: int = -1):
	if num <= 0: jump_to_checkpoint(get_nearest_checkpoint())
	elif all_checkpoints[num-1].reached:
		player.global_position = all_checkpoints[num-1].global_position
	else: jump_to_checkpoint(num-1)

func on_cookbook_collected(book_num: int):
	cookbooks_held += 1
	counter.text = "Find Santa's Cookbooks! %d/%d" % [cookbooks_held, max_cookbooks]
	var child_name = "Cookbook%d" % book_num
	var child_node = get_node(child_name)
	call_deferred("remove_child", child_node)
	if cookbooks_held >= max_cookbooks:
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
		jump_to_checkpoint()
