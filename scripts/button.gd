extends Button

func _ready():
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exit)

func on_mouse_enter():
	modulate.a = 0.5

func on_mouse_exit():
	modulate.a = 1.0
