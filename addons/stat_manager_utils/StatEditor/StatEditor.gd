@tool
extends Control

@export var reference : GlobalStatConfigData : set = set_reference

@onready var ButtonNew=%New
@onready var ButtonOpen=%Open

@onready var FDNew: FileDialog=$%FileDialogNew
@onready var FDOpen: FileDialog=%FileDialogOpen

@onready var LabelFileName: Label=$%FileName

@onready var stat_graph_view = %StatGraphView

func _ready():
	print(get_children())

func NewButton_pressed():
	FDNew.popup_centered(Vector2(500,500))
	
func OpenButton_pressed():
	FDOpen.popup_centered()


func on_button_new_file(path : String):
	new_file(path)

func on_button_open_file(path:String):
	print(path)
	if FileAccess.file_exists(path):
		open_file(path)
	else:
		new_file(path)

func open_file(path) -> Error:
	if FileAccess.file_exists(path):
		var parser := StatConfigDataParser.new()
		
		var file :=FileAccess.open(path,FileAccess.READ)
		
		var err := parser.parse_raw_statres(file.get_as_text())
		
		file.close()
		
		if err != OK:
			printerr("Stat Manager Plugin: Error while parsing during loadup (not import) "+path+"; additional information: "+parser.get_error())
			return err
		reference=parser.get_config_data()
		reference._last_save_path=path
		update_UI()
		return OK
	return ERR_FILE_NOT_FOUND

func save_file(path):
	if not path:
		return
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	var parser = StatConfigDataParser.new()
	parser.parse_config_resource(reference)
	reference._last_save_path=path
	file.store_string(parser.get_config_safefile())
	update_UI()

func new_file(path):
	print("Stat Manager Plugin: Creating new file at path: "+path)
	reference = GlobalStatConfigData.new()
	reference._last_save_path=path
	save_file(path)
	update_UI()

func add_and_open_resource(resource : GlobalStatConfigData):
	if is_instance_valid(reference) and not reference._last_save_path.is_empty():
		save_file(reference._last_save_path)
	reference=resource
	update_UI()

func set_reference(new_reference : GlobalStatConfigData):
	reference=new_reference
	if stat_graph_view:
		stat_graph_view.reference=reference

func update_UI():
	if is_instance_valid(reference):
		if not reference._last_save_path.is_empty():
			LabelFileName.text=reference._last_save_path
		else:
			LabelFileName.text="Unknown"
	else:
		LabelFileName.text="There is no loaded file"



func _on_visibility_changed():
	if visible:
		call_deferred("update_UI")
