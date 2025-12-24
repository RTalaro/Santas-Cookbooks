extends Control


@onready var play = $VBoxContainer2/Buttons/Play
@onready var options = $VBoxContainer2/Buttons/Options
@onready var quit = $VBoxContainer2/Buttons/Quit

func _ready():
	play.connect("button_down", on_play_button_down)
	quit.connect("button_down", on_quit_button_down)


func on_play_button_down():
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func on_quit_button_down():
	get_tree().quit()
