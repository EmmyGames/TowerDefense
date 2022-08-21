extends Node

class_name Upgrade

enum Stat {DAMAGE, RANGE, FIRE_RATE}
enum Type {FLAT, PERCENT}

export var stat = Stat.DAMAGE
export var modifier : float
export var type = Type.FLAT
export var cost : int
