@tool
extends GraphEdit

var current_config : GlobalStatConfigData : set = change_current_config

@export var SetGraphNode : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var hbox=get_menu_hbox()
	hbox.add_child(load("res://AddPageButton.tscn").instantiate())
	add_valid_connection_type(0,0)
	add_valid_connection_type(1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_current_config(new_config : GlobalStatConfigData):
	current_config=new_config
	recreate_config_resource(current_config)

func _on_connection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int):
	if get_all_port_connections(to_node,to_port).size()>0:
		return
	
	if from_node==to_node:
		return
	
	for i in get_children():
		if i.name==to_node:
			for c in i.get_children():
				if c.name==from_node:
					return
			i.connection_create(from_node,from_port,to_port)
			break
	print(connect_node(from_node,from_port,to_node,to_port))

func _on_disconnection_request(from_node, from_port, to_node, to_port):
	for i in get_children():
		if i.name==to_node:
			i.connection_delete(from_node,from_port,to_port)
			break
	disconnect_node(from_node,from_port,to_node,to_port)

func clear_children():
	while get_child_count()>0:
		var child=get_child(0)
		remove_child(child)
		if child:
			child.queue_free()

func get_all_port_connections(to_node : StringName, to_port : int):
	var dicts = get_connection_list()
	var connections=[]
	for i in dicts:
		if i["to_node"]==to_node and i["to_port"]==to_port or i["from_node"]==to_node and i["from_port"]==to_port:
			connections.append(i)
	return connections

func _on_popup_request(position):
	if current_config:
		print("Stat Manager Plugin: wanting to open a new setnode")
		create_set_node(position)

func recreate_config_resource(resource : GlobalStatConfigData):
	clear_children()
	for i in resource.sets:
		create_set_node(Vector2(0,0),i)
		
	arrange_nodes()

func remap_connections_port(from_node : GraphNode, old_port : int, new_port :int ):
	var moving_connections : Array[Dictionary] =[]
	for i in get_connection_list():
		if i["from_node"]==from_node.name and i["from_port"]==old_port:
			moving_connections.append(i)
	for i in moving_connections:
		disconnect_node(i["from_node"],i["from_port"],i["to_node"],i["to_port"])
		connect_node(i["from_node"],new_port,i["to_node"],i["to_port"])

func shift_left_connections(from_node : GraphNode, after_port :int, by_pos :int):
	var moving_connections : Array[Dictionary] =[]
	for i in get_connection_list():
		if i["to_node"]==from_node.name and i["to_port"]>=after_port:
			moving_connections.append(i)
	for i in moving_connections:
		disconnect_node(i["from_node"],i["from_port"],i["to_node"],i["to_port"])
		connect_node(i["from_node"],i["from_port"],i["to_node"],i["to_port"]+by_pos)

func create_set_node(position : Vector2=Vector2(250,250),linked_set : GlobalStatConfigData.statSet=null):
	if current_config and not linked_set:
		linked_set=current_config.append_and_create_new_set()
	var newGraphNode = SetGraphNode.instantiate()
	if newGraphNode.has_method("set_linked_set"):
		newGraphNode.set_linked_set(linked_set)
	else:
		printerr("Stat Manager Plugin: Wrongly set GraphNode reference in the Stat Editor graphing module")
	add_child(newGraphNode)
	newGraphNode.position=position

func create_stat_node():
	pass



