extends Control


@onready var menu = $Menu
@onready var play = $Menu/Buttons/Play
@onready var options = $Menu/Buttons/Options
@onready var quit = $Menu/Buttons/Quit
@onready var volume = $Volume
@onready var back = $Volume/Back

func _ready():
	play.connect("button_down", on_play_button_down)
	options.connect("button_down", on_options_button_down)
	back.connect("button_down", on_back_button_down)
	quit.connect("button_down", on_quit_button_down)


func on_play_button_down():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func on_options_button_down():
	menu.visible = false
	volume.visible = true

func on_back_button_down():
	volume.visible = false
	menu.visible = true

func on_quit_button_down():
	get_tree().quit()


func _input(_event):
	if Input.is_action_just_pressed("options"):
		if menu.visible: on_options_button_down()
		else: on_back_button_down()
