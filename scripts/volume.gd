extends Control

@onready var back = $Back
@onready var master = $HBoxContainer/Sliders/Master
@onready var music = $HBoxContainer/Sliders/Music
@onready var sfx = $HBoxContainer/Sliders/SFX

func _ready():
	back.button_down.connect(on_back_button_down)

func on_back_button_down():
	visible = false
