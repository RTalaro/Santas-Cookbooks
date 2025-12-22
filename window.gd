extends Area2D

func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		var parent = get_parent()
		if parent:
			if parent.num_cookbooks >= 7: parent.quest_complete.emit()
			else: print("insufficient cookbooks")
		else: print("no parent")
	else: print("unknown body entered window")
