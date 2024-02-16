class_name StatConfigDataParser
## This is a helper class, used to compile raw, readable stat-config-code into the config resource used by the stat manager

var _build_res : GlobalStatConfigData

var _build_text : String

var _error_hint : String= ""

const stat_info_separator = " - "
const config_part_separator = "#"
const set_name_statlist_separator = ": "
const set_stats_separator = ", "


func parse_raw_statres(input_strings : String) -> Error:
	_error_hint=""
	var lines = input_strings.split("\n")
	
	var StatConfigs : Array[GlobalStatConfigData.statConfig] = []
	var fastAccessStatDict={}
	var SetConfigs : Array[GlobalStatConfigData.statSet] = []
	var i=0
	### reading StatConfigs
	while(i < lines.size() and not lines[i].begins_with(config_part_separator)):
		var lineData = lines[i].split(stat_info_separator)
		if lineData.size()!=2:
			_error_hint="wrongly separated stat definition in line "+str(i+1)
			return ERR_PARSE_ERROR
		var config : GlobalStatConfigData.statConfig =GlobalStatConfigData.statConfig.new()
		config.id=i;
		config.name= lineData[0]
		match lineData[1]:
			"RESTRICTING":
				config.type=GlobalStatConfigData.statUtilizationType.RESTRICTING
			"DEFINING":
				config.type=GlobalStatConfigData.statUtilizationType.DEFINING
			"SCALING":
				config.type=GlobalStatConfigData.statUtilizationType.SCALING
			_:
				_error_hint="wrongly declared stat usage type in line "+str(i)
				return ERR_PARSE_ERROR
		StatConfigs.append(config)
		fastAccessStatDict[config.name]=config
		i+=1
	i+=1
	### reading set configs
	while(i < lines.size()):
		var config : GlobalStatConfigData.statSet = GlobalStatConfigData.statSet.new()
		var data = lines[i].split(set_name_statlist_separator)
		if data.size()!=2:
			_error_hint="line "+str(i)+" is wrongly separated into parts"
			return ERR_PARSE_ERROR
		config.name=data[0]
		var statReferences=data[1].split(set_stats_separator)
		for statRef in statReferences:
			if statRef in fastAccessStatDict:
				config.stats.append(fastAccessStatDict[statRef])
			else:
				_error_hint="line "+str(i)+" holds references to the non-existing stat "+statRef+", check for typos maybe"
				return ERR_PARSE_ERROR
		SetConfigs.append(config)
		i+=1
	_build_res=GlobalStatConfigData.new()
	_build_res.stats=StatConfigs
	_build_res.sets=SetConfigs
	return OK

func parse_config_resource(resource : GlobalStatConfigData) -> Error:
	var lines = []
	var statList=resource.stats.duplicate()
	statList.sort_custom( func(x,y): return (x.id<y.id))
	for i : GlobalStatConfigData.statConfig in statList:
		var line = i.name
		line+=stat_info_separator
		match i.type:
			GlobalStatConfigData.statUtilizationType.RESTRICTING:
				line+="RESTRICTING"
			GlobalStatConfigData.statUtilizationType.DEFINING:
				line+="DEFINING"
			GlobalStatConfigData.statUtilizationType.SCALING:
				line+="SCALING"
		lines.append(line)
	
	lines.append(config_part_separator+"####")
	for i : GlobalStatConfigData.statSet in resource.sets:
		var line=i.name+set_name_statlist_separator
		for stat in i.stats:
			line+=stat.name
			line+=set_stats_separator
		line.substr(0,line.length()-set_stats_separator.length())
	
	_build_text="\n".join(lines)
	return OK

func get_error():
	return _error_hint

func get_config_data() -> GlobalStatConfigData:
	return _build_res


## call after parse_config_resource to get the result
func get_config_safefile():
	return _build_text
