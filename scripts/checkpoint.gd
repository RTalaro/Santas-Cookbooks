extends Area2D

@export var num = 0
@export var reached = false

@onready var reach_sfx = $ReachSFX

func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		var parent = get_parent()
		if parent:
			reach_sfx.play()
			print("checkpoint %d reached" % num)
			reached = true
			call_deferred("disconnect", "body_entered", on_body_entered)
		else: print("no parent")


func _input(_event):
	if reached and Input.is_action_just_pressed(str(num)):
		if get_parent():
			get_parent().jump_to_checkpoint(num)
