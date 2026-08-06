class_name ValidationRegistry
extends RefCounted

const CHECKS_PATH := "res://course/checks.json"

var configuration: Dictionary = {}
var last_error := ""


func load_checks() -> bool:
	last_error = ""
	if not FileAccess.file_exists(CHECKS_PATH):
		last_error = "缺少验证配置：%s" % CHECKS_PATH
		return false
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(CHECKS_PATH))
	if not (parsed is Dictionary):
		last_error = "验证配置不是有效 JSON。"
		return false
	configuration = parsed
	return true


func get_rule(exercise_id: String) -> Dictionary:
	var defaults: Dictionary = configuration.get("defaults", {}).duplicate(true)
	var specific: Dictionary = configuration.get("exercises", {}).get(exercise_id, {})
	return _deep_merge(defaults, specific)


func check_contracts(exercise_id: String, source: String) -> Dictionary:
	var contracts: Dictionary = get_rule(exercise_id).get("contracts", {})
	var failures: Array[String] = []
	var passes: Array[String] = []

	for requirement in contracts.get("required", []):
		var pattern: String = requirement.get("pattern", "")
		var label: String = requirement.get("label", pattern)
		if _matches(source, pattern):
			passes.append(label)
		else:
			failures.append("缺少：%s" % label)

	for forbidden in contracts.get("forbidden", []):
		var pattern: String = forbidden.get("pattern", "")
		var label: String = forbidden.get("label", pattern)
		if _matches(source, pattern):
			failures.append("不应包含：%s" % label)
		else:
			passes.append("未包含：%s" % label)

	return {"passed": failures.is_empty(), "passes": passes, "failures": failures}


func compare_images(exercise_id: String, actual: Image, expected: Image) -> Dictionary:
	if actual == null or expected == null or actual.is_empty() or expected.is_empty():
		return {"passed": false, "error": "预览图像不可用。"}

	var visual: Dictionary = get_rule(exercise_id).get("visual", {})
	var sample_size: int = visual.get("sample_size", 64)
	var left := actual.duplicate()
	var right := expected.duplicate()
	left.resize(sample_size, sample_size, Image.INTERPOLATE_LANCZOS)
	right.resize(sample_size, sample_size, Image.INTERPOLATE_LANCZOS)
	left.convert(Image.FORMAT_RGBA8)
	right.convert(Image.FORMAT_RGBA8)

	var total_error := 0.0
	var bad_pixels := 0
	var pixel_threshold: float = visual.get("pixel_error", 0.12)
	var pixel_count := sample_size * sample_size
	for y in range(sample_size):
		for x in range(sample_size):
			var a: Color = left.get_pixel(x, y)
			var b: Color = right.get_pixel(x, y)
			var error := (absf(a.r - b.r) + absf(a.g - b.g) + absf(a.b - b.b) + absf(a.a - b.a)) * 0.25
			total_error += error
			if error > pixel_threshold:
				bad_pixels += 1

	var mean_error := total_error / float(pixel_count)
	var bad_pixel_ratio := float(bad_pixels) / float(pixel_count)
	var max_mean: float = visual.get("mean_error", 0.045)
	var max_bad_ratio: float = visual.get("max_bad_pixel_ratio", 0.12)
	return {
		"passed": mean_error <= max_mean and bad_pixel_ratio <= max_bad_ratio,
		"mean_error": mean_error,
		"mean_error_limit": max_mean,
		"bad_pixel_ratio": bad_pixel_ratio,
		"bad_pixel_ratio_limit": max_bad_ratio
	}


func combine_results(exercise_id: String, visual_result: Dictionary, contract_result: Dictionary, manual_confirmed: bool) -> Dictionary:
	var rule := get_rule(exercise_id)
	var mode: String = rule.get("mode", "visual")
	var needs_visual := mode.contains("visual")
	var needs_contract := mode.contains("contract")
	var needs_manual := mode.contains("manual")
	var failures: Array[String] = []

	if needs_visual and not visual_result.get("passed", false):
		failures.append("画面与参考结果仍有明显差异。")
	if needs_contract and not contract_result.get("passed", false):
		failures.append_array(contract_result.get("failures", []))
	if needs_manual and not manual_confirmed:
		failures.append("还需要完成观察清单。")

	return {
		"passed": failures.is_empty(),
		"mode": mode,
		"failures": failures,
		"manual_checklist": rule.get("manual_checklist", []),
		"visual": visual_result,
		"contracts": contract_result
	}


static func _matches(source: String, pattern: String) -> bool:
	if pattern.is_empty():
		return true
	var regex := RegEx.new()
	if regex.compile(pattern) != OK:
		return false
	return regex.search(source) != null


static func _deep_merge(base: Dictionary, overlay: Dictionary) -> Dictionary:
	var merged := base.duplicate(true)
	for key in overlay:
		if merged.get(key) is Dictionary and overlay[key] is Dictionary:
			merged[key] = _deep_merge(merged[key], overlay[key])
		else:
			merged[key] = overlay[key]
	return merged
