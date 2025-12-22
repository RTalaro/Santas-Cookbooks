extends Control

@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer
@onready var textbox = $CanvasLayer/Textbox
@onready var text = $CanvasLayer/Textbox/InnerRect/Text
@onready var player = $Player
@onready var santa = $Santa
@onready var santa_sprite = $Santa/Sprite2D
@onready var camera = $Camera2D

@export var last_checkpoint = 0
@export var num_cookbooks = 0

signal proceed_text

func _ready():
	player.set_physics_process(false)
	text.text = ""
	run_dialogue("start")

func run_dialogue(file_name: String):
	var dialogue_path = "res://dialogue/%s.txt" % file_name
	var dialogue = FileAccess.open(dialogue_path, FileAccess.READ)
	animation_player.play("textbox_fade_in")
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
	santa.global_position = Vector2(1,2)
	santa_sprite.flip_h = true
	player.set_physics_process(true)

func reset_game():
	player.global_position = player.origin


func _process(_delta):
	if textbox.modulate == Color(1.0,1.0,1.0,1.0) and Input.is_action_just_pressed("proceed_text"):
		proceed_text.emit()
	
	camera.position.x = player.position.x
	if player.global_position.y > 700:
		reset_game()
