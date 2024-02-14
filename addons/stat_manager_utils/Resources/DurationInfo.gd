extends Resource
class_name DurationInformation

var duration_total : GameTimeInfo
var duration_passed : GameTimeInfo

var _has_ended:bool = false
var start_over:bool=false
var is_infinite:bool=false

signal duration_over

func _init(duration:GameTimeInfo,infite=false,repeat=false):
	
	duration_total=duration
	duration_passed=GameTimeInfo.new(duration.time_type,0)
	start_over=repeat
	is_infinite=infite

#static func decode_json(json_dict):
#	return DurationInformation.new(GameTimeInfo.decode_json(json_dict["time"]),json_dict["is_infinite"],json_dict["repeating"])

func restart():
	_has_ended=false
	duration_passed=GameTimeInfo.new(duration_total.time_type,0)

func advance(time:GameTimeInfo):
	if _has_ended:
		return
	if not is_infinite:
		duration_passed.advance(time)
	
	if GameTimeInfo.difference(duration_total,duration_passed)<=0:
		duration_over.emit()
		
		if start_over:
			duration_passed.amount=0
		else:
			_has_ended=true


