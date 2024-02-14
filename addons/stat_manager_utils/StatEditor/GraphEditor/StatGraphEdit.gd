@tool
extends GraphEdit

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


func _on_connection_request(from_node : StringName, from_port : int, to_node : StringName, to_port : int):
	if get_all_port_connections(to_node,to_port).size()>0:
		return
	for i in get_children():
		if i.name==to_node:
			i.connection_request(from_node,from_port,to_port)
			break
	print(connect_node(from_node,from_port,to_node,to_port))

func _on_disconnection_request(from_node, from_port, to_node, to_port):
	disconnect_node(from_node,from_port,to_node,to_port)



func get_all_port_connections(to_node : StringName, to_port : int):
	var dicts = get_connection_list()
	var connections=[]
	for i in dicts:
		if i["to_node"]==to_node and i["to_port"]==to_port or i["from_node"]==to_node and i["from_port"]==to_port:
			connections.append(i)
	return connections

func _on_popup_request(position):
	pass # Replace with function body.

func recreate_config_resource(resource : GlobalStatConfigData):
	pass

func remap_connections(from_node : GraphNode, old_port : int, new_port :int ):
	var moving_connections : Array[Dictionary] =[]
	for i in get_connection_list():
		if i["from_node"]==from_node.name and i["from_port"]==old_port:
			moving_connections.append(i)
	for i in moving_connections:
		disconnect_node(i["from_node"],i["from_port"],i["to_node"],i["to_port"])
		connect_node(i["from_node"],new_port,i["to_node"],i["to_port"])

func create_set_node():
	pass

func create_stat_node():
	pass



