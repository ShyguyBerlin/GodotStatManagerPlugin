extends Resource
class_name StatInformation

var base:StatInfoBase
var _changes_multiplicative={}
var _changes_additive={}
var level=0

func _init(base):
	self.base=base
	super(base.name,base.get_value())
	name=base.name
#	base.value_changed.connect(update_value)
	update_value()

func update_value():
	# all multiplicative changes
	var cm = 1
	# all additive changes
	var ca = 0
	
	# calculate total multiplier my multiplying different multipliers
	for i in _changes_multiplicative:
		cm*=_changes_multiplicative[i]
	
	# add all additive changes
	for i in _changes_additive:
		ca+=_changes_additive[i]
	
	base.apply_level(level)
	var new_val=base.get_value()*cm+ca
	
	if new_val!=_currentValue:
		value_changed.emit(_currentValue,new_val)
		_currentValue=new_val

func apply_level(level):
	base.apply_level(level)

func get_value():
	return _currentValue

func add_multiplicative_modifier(value,identifier="unnamed"):
	_generalize_identifier(_changes_multiplicative,identifier)
	if _changes_multiplicative.has(identifier):
		_changes_multiplicative[identifier]*=value
	else:
		_changes_multiplicative[identifier]=value
	if absf(_changes_multiplicative[identifier]-1)<0.001:
		_changes_multiplicative.erase(identifier)
	update_value()

func add_additive_modifier(value,identifier="unnamed"):
	_generalize_identifier(_changes_additive,identifier)
	if _changes_additive.has(identifier):
		_changes_additive[identifier]+=value
	else:
		_changes_additive[identifier]=value
	if absf(_changes_additive[identifier])<0.001:
		_changes_multiplicative.erase(identifier)
	update_value()
	
	
	
