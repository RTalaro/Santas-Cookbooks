extends Area2D

@export var num = 0
@export var collected = false

func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		var parent = get_parent()
		if parent:
			parent.cookbook_collected.emit(num)
			collected = true
			visible = false
			call_deferred("disconnect", "body_entered", on_body_entered)
		else: print("no parent")
	else: print("unknown body entered cookbook", num)
