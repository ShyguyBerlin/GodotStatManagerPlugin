class_name StatusEffectInfo

## a list of possible effects, the effect an instance of this class takes must be one of these
enum possible_effects {
	DAMAGE_OVER_TIME=0, ## Applies it's strength as damage every combat tick
	STUN=1, ## If a unit is stunned it cannot take an action
	STAT_CHANGE_MUL=2, ## changes a stat by multiplying it by the status's strength
	STAT_CHANGE_ADD=3, ## changes a stat by adding the status's strength to it
}

const __effect_string_conversion_dict = {
	"damage_over_time":0,
	"stun":1,
	"stat_change_multiplicative":2,
	"stat_change_additive":3
}

var origin : CombatParticipant
var name : String
var effect : possible_effects
var additional_info : Dictionary
var duration : DurationInfo
var is_bad : bool

func _init(origin:CombatParticipant,name:String,effect_type:possible_effects,info_dict:Dictionary,duration:DurationInfo,bad:bool=true):
	self.origin=origin
	self.name=name
	self.effect=effect_type
	self.additional_info=info_dict
	self.duration=duration
	self.duration.start_over=false
	self.is_bad=bad

static func decode_json(json_dict):
	var org=null
	var name=json_dict["name"]
	var effect=__effect_string_conversion_dict[json_dict["type"]]
	var info = json_dict["additional_effect_info"]
	var duration = DurationInfo.decode_json(json_dict["duration"])
	var is_bad=json_dict["is_bad"]
	var newStatus=StatusEffectInfo.new(org,name,effect,info,duration,is_bad)
	return newStatus
	

func advance_duration(time:GameTimeInfo):
	duration.advance(time)

func apply_on_stat_page(stat_info : StatPageModifiers):
	if not name:
		name="unnamed"
	if effect==possible_effects.STAT_CHANGE_ADD:
		stat_info.add_additive_modifier(additional_info["type"],additional_info["strength"],name)
	if effect==possible_effects.STAT_CHANGE_MUL:
		stat_info.add_multiplicative_modifier(additional_info["type"],additional_info["strength"],name)

func remove_from_stat_page(stat_info : StatPageModifiers):
	if effect==possible_effects.STAT_CHANGE_ADD:
		stat_info.add_additive_modifier(additional_info["type"],-additional_info["strength"],name)
	if effect==possible_effects.STAT_CHANGE_MUL:
		stat_info.add_multiplicative_modifier(additional_info["type"],1/additional_info["strength"],name)
