extends Node

class_name Upgrade

enum Stat {DAMAGE, RANGE, FIRE_RATE}
enum Type {FLAT, PERCENT}

export(Stat) var stat = Stat.DAMAGE
export var modifier : float
export(Type) var type = Type.FLAT
export var cost : int
