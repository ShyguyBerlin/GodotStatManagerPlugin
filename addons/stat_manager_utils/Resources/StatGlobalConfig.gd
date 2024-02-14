@tool
extends Resource
class_name GlobalStatConfigData
## A data container for saving all stats configured and/or used by a project

##The use case for a certain stat, isn't used much by now, but can give some clarity of which interactions have to be implemented
enum statUtilizationType{
	## Used for stats like health, restricting a variable process, like healing and damage taking
	RESTRICTING,
	## Defining or influencing the effects of certain actions, should not be used for long-time checks;
	## Use for e.g. attack_damage, ability power, luck etc.
	DEFINING,
	## Used for stats that affect long time processes, like movement speed (in certain games) or cooldown related calculations.
	SCALING,
}

@export var _last_save_path : String = ""

@export var stats : Array[statConfig]
@export var sets : Array[statSet]

##The defining properties of a stat
class statConfig extends Resource:
	var id:int
	var name:String
	var type:statUtilizationType

class statSet extends Resource:
	var name:String
	var stats:Array[statConfig]

