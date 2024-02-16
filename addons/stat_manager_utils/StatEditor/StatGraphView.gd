extends Control

var reference : GlobalStatConfigData : set = set_reference

@onready var graph_edit=%GraphEdit

func set_reference(new_reference : GlobalStatConfigData):
	reference=new_reference
	if graph_edit:
		graph_edit.current_config=reference
	else:
		printerr("Stat Manager Plugin: StatGraphView couldn't find editor on startup and is now fuuked up")
