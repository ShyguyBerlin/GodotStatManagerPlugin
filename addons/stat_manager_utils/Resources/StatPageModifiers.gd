class_name StatPageModifiers

# this is too old omg how many times do i have to try until it works good enough

# similar to statPage list, but doesnt include growth or exponents, so no extra class needed
var base:StatPageBase

func _init(base_page:StatPageBase):
	base=base_page
	for i in base.stats:
		stats[i]=StatInfoModifying.new(base.stats[i])

func add_additive_modifier(stat_name:String,value:float=0,identifier:String="unnamed"):
	if stats[stat_name]:
		stats[stat_name].add_additive_modifier(value,identifier)

func add_multiplicative_modifier(stat_name:String,value:float=1,identifier:String="unnamed"):
	if stats[stat_name]:
		stats[stat_name].add_multiplicative_modifier(value,identifier)

func apply_level(lvl):
	for i in stats:
		stats[i].level=lvl
		stats[i].update_value()
