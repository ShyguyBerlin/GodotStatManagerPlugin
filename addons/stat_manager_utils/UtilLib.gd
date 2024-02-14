class_name StatUtilLib

static func generalizeStatusKey(base_dict,name:String):
	if name=="unnamed":
		var i=0
		name="unnamed"+str(i)
		while base_dict[name]:
			i+=1
			name="unnamed"+str(i)
	return name
