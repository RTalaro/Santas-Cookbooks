extends Area2D

@export var book_num = 0

func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		var parent = get_parent()
		if parent: parent.cookbook_collected.emit(book_num)
		else: print("no parent")
	else: print("unknown body entered cookbook", book_num)
