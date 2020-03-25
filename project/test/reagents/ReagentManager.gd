extends Node

const REAGENT = preload("res://test/reagents/Reagent.tscn")
var REAGENT_DB = preload("res://database/ReagentDB.gd").new()

func random_type():
	var types = REAGENT_DB.get_types()
	randomize()
	types.shuffle()
	return types[1]

func create_object(type):
	
	var reagent_data = REAGENT_DB.get(type)
	
	var reagent = REAGENT.instance()
	reagent.type = type
	reagent.set_image(reagent_data.image)
	return reagent

func get_data(type):
	return REAGENT_DB.get(type)