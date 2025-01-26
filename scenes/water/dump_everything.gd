extends Node


func dump_body(body : RID):
	var s = PhysicsServer2D
	print(s.body_get_collision_layer(body))
	print(s.body_get_collision_mask(body))
	print(s.body_get_collision_priority(body))
	print(s.body_get_max_contacts_reported(body))
	print(s.body_get_mode(body))
	print(s.body_get_space(body))
	pass
