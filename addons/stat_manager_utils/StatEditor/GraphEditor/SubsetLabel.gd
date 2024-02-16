@tool
extends Label

@export var underline_visible : bool : set = set_underline

@onready var underline = %Underline

var managing_graph_edit : GraphEdit
var managing_graph_node : GraphNode

# Called when the node enters the scene tree for the first time.
func _ready():
	set_underline(underline_visible)

func insert_set_title(title : String):
	text="> "+title

func set_underline(vis: bool):
	if underline:
		underline.visible=vis
	underline_visible=vis
