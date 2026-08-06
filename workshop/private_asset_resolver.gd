class_name PrivateAssetResolver
extends RefCounted

const PRIVATE_ROOT := "res://assets_v17/assets"


func is_available() -> bool:
	return DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(PRIVATE_ROOT))


func status() -> Dictionary:
	return {
		"available": is_available(),
		"root": PRIVATE_ROOT,
		"mode": "private_reference" if is_available() else "self_contained"
	}


func resolve(relative_path: String, fallback_path: String = "") -> String:
	var normalized := relative_path.trim_prefix("/")
	var candidate := "%s/%s" % [PRIVATE_ROOT, normalized]
	if ResourceLoader.exists(candidate) or FileAccess.file_exists(candidate):
		return candidate
	return fallback_path


func main_reference_scene() -> String:
	return resolve("main.tscn")
