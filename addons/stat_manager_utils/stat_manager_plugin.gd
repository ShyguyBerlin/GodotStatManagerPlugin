@tool
extends EditorPlugin

var dock;

var resource_import_plugin

func _handles(object) -> bool:
	return object is GlobalStatConfigData


func _edit(object) -> void:
	if is_instance_valid(dock) and is_instance_valid(object):
		dock.add_and_open_resource(object)

func _enter_tree():
	dock = preload("res://addons/stat_manager_utils/StatEditor/StatEditor.tscn").instantiate()
	
	resource_import_plugin=StatConfigDataImport.new()
	add_import_plugin(resource_import_plugin)
	
	# Add the loaded scene to the docks.
	get_editor_interface().get_editor_main_screen().add_child(dock)
	# add_control_to_container(CONTAINER_TOOLBAR, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.
	_make_visible(false)

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the dock.
	remove_import_plugin(resource_import_plugin)
	resource_import_plugin=null
	if is_instance_valid(dock):
		dock.queue_free()
	# remove_control_from_container(CONTAINER_TOOLBAR,dock)
	# Erase the control from the memory.
	dock.queue_free()

func _make_visible(visible):
	if dock:
		dock.visible=visible

func _get_plugin_icon():
	return "res://icon.svg"

func _get_plugin_name():
	return "Stat Editor"

func _has_main_screen():
	return true
