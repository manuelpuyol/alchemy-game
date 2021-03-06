extends Reference

var image = "res://assets/images/enemies/healer/idle.png"
var name = "Mender Homunculus"
var sfx = "toxic_slime"
var use_idle_sfx = false
var hp = 80
var battle_init = true
var size = "small"
var change_phase = null

var states = ["attack", "defend", "heal", "init"]
var connections = [
					  ["init", "attack", 1],
					  ["init", "defend", 1],  
					  ["heal", "attack", 1],
					  ["heal", "defend", 1],
					  ["attack", "attack", 1],
					  ["attack", "defend", 1],
					  ["attack", "heal", 2],
					  ["defend", "attack", 1],
					  ["defend", "defend", 1],
					  ["defend", "heal", 2],
					  
				  ]
var first_state = ["init"]

var actions = {
	"init": [
		{"name": "shield", "value": 35},
	],
	"attack": [
		{"name": "damage", "value": 10, "type": "regular"},
		{"name": "heal", "value": [5,10], "target": "all_enemies"},
	],
	"defend": [
		{"name": "shield", "value": [10, 35]},
		{"name": "heal", "value": [5,10], "target": "all_enemies"},
	],
	"heal": [
		{"name": "heal", "value": [10,20], "target": "all_enemies"},
		{"name": "status", "status_name": "perm_strength", "value": 6, "target": "self", "positive": true},
	],
}
