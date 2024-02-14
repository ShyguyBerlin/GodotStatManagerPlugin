extends Resource
class_name TimeType
## Base time to configure a way of measuring time in a game
##
## Independent time measures may have their own TimeType accessible by name through TIME_TYPES and get_time_type_by_name

## The list of all Time Types loaded in the current setup. May cause issues if types outside this array are used.
static var TIME_TYPES : Array[TimeType]

## This is a provided time-type provided for real-time purposes
static var REAL_TIME : TimeType = TimeType.new("realtime")

## This is a provided time-type provided for round-time purposes
static var ROUND_TIME : TimeType = TimeType.new("roundtime")

## This is the system name of a time type, it should be clear which name is given for a specific type
@export var name : String;

func _init(name :String="unnamed_timetype"):
	_register_time_type(self)
	self.name=name

## Validates a new type,
static func _register_time_type(type : TimeType):
	for i : TimeType in TIME_TYPES:
		if i==type or i.name==type.name:
			assert(false, "A duplicate time type was generated in code. Delete all time type initializations, that are not bound to a singleton!")
	TIME_TYPES.append(type)

static func get_time_type_by_name(name : String):
	for i in TIME_TYPES:
		if i.name==name:
			return i
	return null
