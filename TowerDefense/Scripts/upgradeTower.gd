extends Button

enum Stat {DAMAGE, RANGE, FIRE_RATE}
enum Type {FLAT, PERCENT}

onready var gs: GameState = get_node("/root/Spatial/GameState")
onready var spatial = get_node("/root/Spatial")
onready var cost_ui = get_node("UpgradeCost")

var current_upgrade : Upgrade

func _ready() -> void:
	connect("pressed", self, "upgrade_tower")
	connect("mouse_entered", self, "mouse_hover")


func upgrade_tower() -> void:
	var tower = gs.current_tower
	current_upgrade = tower.upgrades[tower.upgrade_index].instance()
	# If the player has enough coin and the tower has enough exp.
	if gs.get_currency() >= current_upgrade.cost and tower.upgrade_index < tower.level - 1:
		Global.emit_signal("button_event", 0)
		match current_upgrade.stat:
			Stat.DAMAGE:
				if current_upgrade.type == Type.FLAT:
					tower.damage += current_upgrade.modifier
				else:
					tower.damage *= (1 + current_upgrade.modifier / 100)
			Stat.RANGE:
				if current_upgrade.type == Type.FLAT:
					tower.range_radius += current_upgrade.modifier
				else:
					tower.range_radius *= (1 + current_upgrade.modifier / 100)
				tower.update_range()
			Stat.FIRE_RATE:
				if current_upgrade.type == Type.FLAT:
					tower.rate_of_fire += current_upgrade.modifier
				else:
					tower.rate_of_fire *= (1 + current_upgrade.modifier / 100)
		gs.pay_for_tower(current_upgrade.cost)
		tower.price_invested += current_upgrade.cost
		tower.upgrade_index += 1
		gs.set_tower_menu(gs.current_tower)
	else:
		Global.emit_signal("button_event", 1)


func update_button_display() -> void:
	var tower = gs.current_tower
	if tower.upgrade_index < tower.upgrades.size():
		var cost_UI = get_node("UpgradeCost")
		current_upgrade = tower.upgrades[tower.upgrade_index].instance()
		text = convert_to_string(current_upgrade)
		cost_UI.text = "Price: " + str(current_upgrade.cost)
		visible = true
	else:
		visible = false
	

func convert_to_string(var upgrade : Upgrade) -> String:
	var description : String = ""
	if upgrade.type == Type.FLAT:
		description = "+" + str(upgrade.modifier)
	else:
		description = "+" + str(upgrade.modifier) + "%"
	match upgrade.stat:
		Stat.DAMAGE:
			description += " Damage"
		Stat.RANGE:
			description += " Range"
		Stat.FIRE_RATE:
			description += " Fire Rate"
	return description
	

func mouse_hover() -> void:
	Global.emit_signal("button_event", 2)
