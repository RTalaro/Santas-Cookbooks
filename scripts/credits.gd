extends Control

@onready var back = $HBoxContainer/Right/Back

func _ready():
	back.connect("button_down", on_back_button_down)

func on_back_button_down():
	get_tree().change_scene_to_file("res://scenes/title.tscn")
