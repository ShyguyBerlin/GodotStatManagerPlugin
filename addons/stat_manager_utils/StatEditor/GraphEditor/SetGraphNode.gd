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
	update_UI()

func createSetSlot():
	var newLabel=label_node.instantiate()
	add_child(newLabel)
	move_child(newLabel,SubSetSlots)
	set_slot_enabled_left(SubSetSlots,true)
	set_slot_enabled_right(SubSetSlots,true)
	set_slot_type_left(SubSetSlots,0)
	set_slot_type_right(SubSetSlots,0)
	if SubSetSlots>0:
		set_slot_enabled_right(SubSetSlots-1,false)
		if graph_editor:
			graph_editor.remap_connections_port(self,SubSetSlots-1,SubSetSlots)
	SubSetSlots+=1
	update_UI()

func createStatSlot():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_linked_set(new_set : GlobalStatConfigData.statSet):
	linked_set=new_set
	update_UI()

func connection_create(fromNode : StringName, fromSlot: int, slot : int):
	if slot==SubSetSlots-1:
		updateLabel(slot,fromNode)
	createSetSlot()
	pass

func connection_delete(fromNode : StringName, fromSlot: int, slot: int):
	if slot<SubSetSlots-1:
		var slotchild = get_child(slot)
		remove_child(slotchild)
		slotchild.queue_free()
		SubSetSlots-=1
	if graph_editor:
		graph_editor.call_deferred("shift_left_connections",self,slot,-1)

func update_UI():
	if linked_set:
		name=linked_set.name
	else:
		name="Unnamed"
	title=name

func updateLabel(slot: int,linkName : String):
		var slotchild : Label= get_child(slot)
		slotchild.text="implementing: "+linkName
		slotchild.tooltip_text="This set is implementing all functionality of "+linkName+"."
		slotchild.set_underline(false)
