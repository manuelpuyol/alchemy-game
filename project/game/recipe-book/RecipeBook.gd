extends Control
class_name RecipeBook

signal recipe_pressed(combination, mastery_unlocked)
signal favorite_toggled(combination, button_pressed)

onready var hand_grid : GridContainer = $Background/HandRect/CenterContainer/HandGrid
onready var hand_rect : ColorRect = $Background/HandRect
onready var recipe_grid : GridContainer = $Background/ScrollContainer/RecipeGrid
onready var scroll : ScrollContainer = $Background/ScrollContainer
onready var tween : Tween = $Tween

const RECIPE = preload("res://game/recipe-book/RecipeDisplay.tscn")
const REAGENT = preload("res://game/recipe-book/ReagentDisplay.tscn")
const RECT_COLOR = Color(0.392157, 0.333333, 0.211765)

enum States {BATTLE, MAP, LAB}

var recipe_displays := {}
var player_bag := []
var state : int = States.MAP



func change_state(new_state: int):
	if new_state == state:
		return
	
	match new_state:
		States.BATTLE:
			hand_rect.visible = true
			scroll.rect_size.y -= hand_rect.rect_size.y
		States.MAP:
			if state == States.BATTLE:
				remove_hand()
				scroll.rect_size.y += hand_rect.rect_size.y
		States.LAB:
			pass
	
	state = new_state


func add_combination(combination: Combination, position: int):
	if recipe_displays.has(combination.recipe.name):
		print("RecipeBook.gd add_combination recipe %s already exists" % combination.recipe.name)
		return
	
	var recipe_display = RECIPE.instance()
	recipe_grid.add_child(recipe_display)
	recipe_grid.move_child(recipe_display, position)
	recipe_display.set_combination(combination)
	recipe_display.connect("hovered", self, "_on_recipe_display_hovered")
	recipe_display.connect("unhovered", self, "_on_recipe_display_unhovered")
	recipe_display.connect("pressed", self, "_on_recipe_display_pressed")
	recipe_display.connect("favorite_toggled", self, "_on_recipe_display_favorite_toggled")
	recipe_displays[combination.recipe.name] = recipe_display


func update_combination(combination: Combination):
	assert(recipe_displays.has(combination.recipe.name),"RecipeBook.gd update_combination: %s not in recipe book" % combination.recipe.name)
	var display = recipe_displays[combination.recipe.name]
	display.update_combination()


func create_hand(battle):
	battle.connect("current_reagents_updated", self, "update_hand")
	hand_grid.columns = int(ceil(battle.hand.size / 2.0))
	for _i in range(battle.hand.size):
		var reagent = REAGENT.instance()
		reagent.rect_min_size = Vector2(100, 100)
		hand_grid.add_child(reagent)


func remove_hand():
	for child in hand_grid.get_children():
		hand_grid.remove_child(child)
	
	hand_rect.visible = false


func toggle_visibility():
	visible = !visible
	
	if visible:
		AudioManager.play_sfx("open_recipe_book")
	else:
		AudioManager.play_sfx("close_recipe_book")
		_on_recipe_display_unhovered()
	
	return visible

func is_mastered(combination : Combination):
	return recipe_displays[combination.recipe.name].is_mastered()
	

func unlock_mastery(combination: Combination):
	recipe_displays[combination.recipe.name].unlock_mastery()


func update_hand(reagents: Array):
	for i in reagents.size():
		hand_grid.get_child(i).set_reagent(reagents[i])


func update_player_bag(bag : Array):
	player_bag = []
	for reagent in bag:
		player_bag.append(reagent.type)


func color_hand_reagents(reagent_array: Array):
	var reagents := reagent_array.duplicate()
	var correct_reagent_displays := []
	var i = 0
	while not reagents.empty() and i < hand_grid.get_child_count():
		var reagent = hand_grid.get_child(i).reagent_name
		for other in reagents:
			if reagent == other:
				correct_reagent_displays.append(hand_grid.get_child(i))
				reagents.erase(other)
				break
		i += 1
	
	if reagents.empty():
		for display in correct_reagent_displays:
			display.self_modulate = Color.green


func reset_hand_reagents_color():
	for display in hand_grid.get_children():
		display.self_modulate = Color.white


func favorite_error(combination: Combination):
	recipe_displays[combination.recipe.name].favorite_error()


func error_effect():
	AudioManager.play_sfx("error")
# warning-ignore:return_value_discarded
	tween.interpolate_property(hand_rect, "color", Color.red, RECT_COLOR,
			.5, Tween.TRANS_SINE, Tween.EASE_IN)
# warning-ignore:return_value_discarded
	tween.start()


func get_hand_reagents():
	var available_reagents = []
	for reagent in hand_grid.get_children():
		available_reagents.append(reagent.reagent_name)
	
	return available_reagents


func get_player_reagents():
	var available_reagents = get_hand_reagents()
	for reagent in player_bag:
		available_reagents.append(reagent)
	
	return available_reagents


func filter_combinations(combinations : Array, filters : Array):
	var filtered_combinations = []
	
	for combination in combinations:
		for recipe_filter in combination.recipe.filters:
			for filter in filters:
				if filter == recipe_filter:
					filtered_combinations.append(combination)
					break
	
	return filtered_combinations

#Given an array of combinations and and array of reagents, returns all combinations
#from the list that can be made with given reagents
func get_valid_combinations(combinations : Array, available_reagents : Array):
	var valid_combinations = []
	for combination in combinations:
		var reagents = available_reagents.duplicate()
		var valid_combination = true
		for comb_reagent in combination.recipe.reagents:
			if reagents.find(comb_reagent) != -1:
				reagents.remove(reagents.find(comb_reagent))
			else:
				valid_combination = false
				break
		if valid_combination:
			valid_combinations.append(combination)
	
	return valid_combinations


func _on_recipe_display_hovered(reagent_array: Array):
	if state == States.BATTLE:
		color_hand_reagents(reagent_array)


func _on_recipe_display_unhovered():
	if state == States.BATTLE:
		reset_hand_reagents_color()


func _on_recipe_display_pressed(combination: Combination, mastery_unlocked: bool):
	if state != States.BATTLE:
		return
	
	if not hand_grid.get_child_count():
		error_effect()
		return
	
	var combination_reagents : Array = combination.recipe.reagents.duplicate()
	
	var i = 0
	while not combination_reagents.empty() and i < hand_grid.get_child_count():
		var reagent = hand_grid.get_child(i).reagent_name
		for other in combination_reagents:
			if reagent == other:
				combination_reagents.erase(other)
				break
		i += 1
	
	if combination_reagents.empty():
		emit_signal("recipe_pressed", combination, mastery_unlocked)
	else:
		error_effect()


func _on_recipe_display_favorite_toggled(combination: Combination, button_pressed: bool):
	emit_signal("favorite_toggled", combination, button_pressed)
