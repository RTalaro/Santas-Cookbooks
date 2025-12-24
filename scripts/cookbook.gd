extends Area2D

@export var num = 0
@export var collected = false

@onready var sprite = $Sprite2D
@onready var collect_sfx = $CollectSFX

func _ready():
	var sprite_path = "res://assets/sprites/cookbook%d.png" % num
	sprite.texture = load(sprite_path)
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		var parent = get_parent()
		if parent:
			collect_sfx.play()
			collected = true
			visible = false
			parent.cookbook_collected.emit(num)
			call_deferred("disconnect", "body_entered", on_body_entered)
		else: print("no parent")
