@tool
extends EditorImportPlugin
class_name StatConfigDataImport

func _get_importer_name():
	return "stat_manager_import"

func _get_visible_name():
	return "Stat System Configuration Data"

func _get_recognized_extensions():
	return ["statres"]

func _get_import_order() -> int:
	return -1000

func _get_priority() -> float:
	return 1000.0

func _get_save_extension():
	return "tres"

func _get_resource_type():
	return "GlobalStatConfigData"

func _get_preset_count():
	return 0

func _get_preset_name(preset_index):
	return "Not defined"

func _get_import_options(path, preset_index):
	return [{"name": "my_option", "default_value": false}]

func _get_option_visibility(path: String, option_name: StringName, options: Dictionary) -> bool:
	return false

func _import(source_file, save_path, options, platform_variants, gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FAILED
	
	var parser = StatConfigDataParser.new()
	if parser.parse_raw_statres(file.get_as_text())!=OK:
		printerr("Stat Manager Plugin: Error while parsing "+source_file+"; additional information: "+parser.get_error())
		return ERR_PARSE_ERROR
	var res := parser.get_config_data()
	
	res._last_save_path=source_file
	
	var statRes= parser.get_config_data()


	var filename = "%s.%s" % [save_path, _get_save_extension()]
	return ResourceSaver.save(statRes, filename)
