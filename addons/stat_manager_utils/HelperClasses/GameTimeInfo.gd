extends Resource
class_name GameTimeInfo

var time_type : TimeType=TimeType.REAL_TIME
var time_amount=0

func _init(type:TimeType,time:float):
	time_type=type
	time_amount=time

#static func decode_json(json_dict=null):
#	if json_dict==null:
#		return GameTimeInfo.new(0,0)
#	if json_dict.has("type") and json_dict.has("amount"):
#		return GameTimeInfo.new(__time_type_string_conversion_dict[json_dict["type"]],float(json_dict["amount"]))

func advance(time:GameTimeInfo):
	if time.time_type==self.time_type:
		time_amount+=time.time_amount

## just returns time1-time2, if types match
static func difference(time1:GameTimeInfo,time2:GameTimeInfo):
	if time1.time_type==time2.time_type:
		return time1.time_amount-time2.time_amount
	else:
		return null
	var a:String=""

func copy():
	return GameTimeInfo.new(time_type,time_amount)
