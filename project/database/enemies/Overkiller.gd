extends Reference

var image = "res://assets/images/enemies/overkiller/idle.png"
var name = "Soulbound Doll"
var sfx = "toxic_slime"
var use_idle_sfx = false
var hp = 60
var battle_init = true
var size = "small"
var change_phase = null

var states = ["init", "attack1", "defend", "attack2", "buff"]
var connections = [
					  ["init", "attack1", 1],
					  ["init", "attack2", 1],
					  ["init", "defend", 1],
					  ["attack1", "defend", 4],
					  ["attack1", "attack1", 6],
					  ["attack1", "attack2", 4],
					  ["attack1", "buff", 2],
					  ["attack2", "defend", 4],
					  ["attack2", "attack1", 6],
					  ["attack2", "attack2", 4],
					  ["attack2", "buff", 2],
					  ["defend", "attack1", 4],
					  ["defend", "attack2", 4],
					  ["defend", "attack2", 2],
					  ["defend", "buff", 1],
					  ["buff", "buff", 1],
					  ["buff", "attack1", 4],
					  ["buff", "attack2", 4],
					  ["buff", "defend", 2],
				  ]
var first_state = ["init"]

var actions = {
	"init": [
		{"name": "status", "status_name": "soulbind", "value": 1, "target": "self", "positive": true},
		{"name": "shield", "value": [5, 10]},
	],
	"attack1": [
		{"name": "damage", "value": [13, 15], "type": "regular"},
		{"name": "shield", "value": [8, 10]},
	],
	"attack2": [
		{"name": "damage", "value": [10, 18], "type": "regular"},
		{"name": "shield", "value": [8, 10]},
	],
	"defend": [
		{"name": "shield", "value": [12, 30]},
	],
	"buff": [
		{"name": "status", "status_name": "perm_strength", "value": 9, "target": "self", "positive": true}
	],
}
