extends Node

var boss_encounters := {}
var elite_encounters := {}
var encounters := {}
var encounter_pool : Array
var encounter_index : int
var elite_encounter_pool : Array
var elite_encounter_index : int
var boss_encounter_pool : Array


func _ready():
	var dir := Directory.new()
	var path := "res://database/encounters/"
	if dir.open(path) == OK:
# warning-ignore:return_value_discarded
		dir.list_dir_begin()
		var file_name := dir.get_next() as String
		while file_name != "":
			if not dir.current_is_dir() and file_name.get_extension() == "tres":
				var encounter := load(str(path, file_name)) as Encounter
				encounter.resource_name = file_name
				if encounter.is_boss:
					if not boss_encounters.has(encounter.level):
						boss_encounters[encounter.level] = []
					boss_encounters[encounter.level].append(encounter)
				elif encounter.is_elite:
					if not elite_encounters.has(encounter.level):
						elite_encounters[encounter.level] = []
					elite_encounters[encounter.level].append(encounter)
				else:
					if not encounters.has(encounter.level):
						encounters[encounter.level] = []
					encounters[encounter.level].append(encounter)
			file_name = dir.get_next()
	else:
		print("EncounterManager: An error occurred when trying to access the path.")


func set_random_encounter_pool(level: int):
	#Regular enemies
	encounter_pool = encounters[level].duplicate()
	encounter_index = 0
	encounter_pool.shuffle()
	
	#Elite enemies
	elite_encounter_pool = elite_encounters[level].duplicate()
	elite_encounter_index = 0
	elite_encounter_pool.shuffle()
	
	#Boss
	boss_encounter_pool = boss_encounters[level].duplicate()
	boss_encounter_pool.shuffle()


func get_random_encounter() -> Encounter:
	if encounter_index >= encounter_pool.size():
		encounter_pool.shuffle()
		encounter_index = 0
	
	var encounter = encounter_pool[encounter_index]
	encounter_index += 1
	return encounter


func get_random_elite_encounter() -> Encounter:
	if elite_encounter_index >= elite_encounter_pool.size():
		elite_encounter_pool.shuffle()
		elite_encounter_index = 0
	
	var encounter = elite_encounter_pool[elite_encounter_index]
	elite_encounter_index += 1
	return encounter


func get_random_boss_encounter() -> Encounter:
	return boss_encounter_pool.pop_front()
