extends Control
class_name FavoriteButton

signal pressed

onready var button = $Button

const MAX_SCALE = 1.1
const SCALE_SPEED = 2

var combination : Combination
var reagent_array : Array
var mouse_over := false
var tooltips_enabled := false
var block_tooltips := false


func _process(delta):
	if mouse_over and not button.disabled:
		button.rect_scale.x = min(button.rect_scale.x + SCALE_SPEED*delta, MAX_SCALE)
		button.rect_scale.y = min(button.rect_scale.y + SCALE_SPEED*delta, MAX_SCALE)
	else:
		button.rect_scale.x = max(button.rect_scale.x - 1.5*SCALE_SPEED*delta, 1)
		button.rect_scale.y = max(button.rect_scale.y - 1.5*SCALE_SPEED*delta, 1) 


func set_combination(new_combination: Combination):
	combination = new_combination
	if combination:
		button.texture_normal = combination.recipe.fav_icon
		reagent_array = combination.recipe.reagents


func enable():
	button.disabled = false
	block_tooltips = false


func disable():
	button.disabled = true
	disable_tooltips()
	block_tooltips = true


func hide_button():
	button.visible = false


func show_button():
	button.visible = true


func disable_tooltips():
	if tooltips_enabled:
		tooltips_enabled = false
		TooltipLayer.clean_tooltips()
		

func _on_Button_pressed():
	if combination:
		emit_signal("pressed")


func _on_Button_mouse_entered():
	if combination:
		AudioManager.play_sfx("hover_favorite_button")
		mouse_over = true


func _on_Button_mouse_exited():
	mouse_over = false


func _on_TooltipCollision_enable_tooltip():
	if block_tooltips or not combination:
		return
	tooltips_enabled = true
	var tooltip = RecipeManager.get_tooltip(combination.recipe, true)
	TooltipLayer.add_tooltip($TooltipPosition.global_position, tooltip.title, \
							 tooltip.text, tooltip.title_image, tooltip.subtitle, true)

func _on_TooltipCollision_disable_tooltip():
	disable_tooltips()
