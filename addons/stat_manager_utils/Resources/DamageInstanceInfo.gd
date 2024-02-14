class_name DamageInstanceInfo

var origin:CombatParticipant
var amount:float
var type:String

func _init(origin:CombatParticipant,amount,type="physical"):
	self.origin=origin
	self.amount=amount
	self.type=type
