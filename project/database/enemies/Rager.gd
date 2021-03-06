extends Reference

var image = "res://assets/images/enemies/rager/idle.png"
var name = "Rune Golem"
var sfx = "toxic_slime"
var use_idle_sfx = false
var hp = 80
var battle_init = true
var size = "medium"
var change_phase = null

var states = ["init", "attack1", "attack2", "attack3"]
var connections = [
					  ["init", "attack1", 1],
					  ["attack1", "attack2", 1],
					  ["attack2", "attack3", 1],
					  ["attack3", "attack1", 1],
				  ]
var first_state = ["init"]

var actions = {
	"init": [
		{"name": "status", "status_name": "enrage", "value": 8, "target": "self", "positive": true}
	],
	"attack1": [
		{"name": "damage", "value": [2, 3], "type": "regular"}
	],
	"attack2": [
		{"name": "damage", "value": [2, 3], "type": "regular"}
	],
	"attack3": [
		{"name": "damage", "value": 1, "amount": 3, "type": "regular"}
	],
}
