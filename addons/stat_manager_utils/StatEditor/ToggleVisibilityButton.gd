@tool
extends Button

@export var minion : Control

@export var anchorHorizontal : float
@export var anchorVertical : float

var start_open : bool
var offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(on_self_pressed)
	if minion:
		start_open=minion.visible
		var diff = position-minion.position
		if start_open:
			diff -= Vector2(anchorHorizontal*minion.size.x,anchorVertical*minion.size.y)
		offset=diff

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_self_pressed():
	if minion:
		minion.visible=!minion.visible
	call_deferred("move_with_minion")

func move_with_minion():
	if minion:
		position=Vector2(anchorHorizontal*minion.size.x,anchorVertical*minion.size.y)*int(minion.visible)+minion.position+offset	
