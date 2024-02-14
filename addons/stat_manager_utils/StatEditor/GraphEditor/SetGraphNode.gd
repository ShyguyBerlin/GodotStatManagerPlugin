@tool
extends GraphNode

var SubSetSlots=0
var linked_set : GlobalStatConfigData.statSet : set = set_linked_set

@export var graph_editor : GraphEdit

@export var label_node : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	createSetSlot()
	createStatSlot()
	set_slot_type_left(2,1)

func createSetSlot():
	var newLabel=label_node.instantiate()
	add_child(newLabel)
	move_child(newLabel,SubSetSlots)
	set_slot_enabled_left(SubSetSlots,true)
	set_slot_enabled_right(SubSetSlots,true)
	set_slot_type_left(SubSetSlots,0)
	if SubSetSlots>0:
		set_slot_enabled_left(SubSetSlots-1,false)
		if graph_editor:
			graph_editor.remap_connections(self,SubSetSlots-1,SubSetSlots)
	SubSetSlots+=1

func createStatSlot():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_linked_set(new_set : GlobalStatConfigData.statSet):
	linked_set=new_set
	update_UI()

func connection_request(fromNode : StringName, fromSlot: int, slot : int):
	#if fromNode.get_output_port_type(fromSlot)==get_input_port_type(slot):
	pass

func update_UI():
	if linked_set:
		title=linked_set.name
	else:
		title="Unnamed"	
