$ErrorActionPreference = 'Stop'
$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$root = Split-Path -Parent $PSScriptRoot
$catalogPath = Join-Path $root 'course\catalog.json'
$checksPath = Join-Path $root 'course\checks.json'
$prepCatalogPath = Join-Path $root 'course\prep_catalog.json'
$prepChecksPath = Join-Path $root 'course\prep_checks.json'
$catalog = Get-Content -Raw -Encoding UTF8 -LiteralPath $catalogPath | ConvertFrom-Json
$checks = Get-Content -Raw -Encoding UTF8 -LiteralPath $checksPath | ConvertFrom-Json
$prepCatalog = Get-Content -Raw -Encoding UTF8 -LiteralPath $prepCatalogPath | ConvertFrom-Json
$prepChecks = Get-Content -Raw -Encoding UTF8 -LiteralPath $prepChecksPath | ConvertFrom-Json
$entries = @($catalog.modules | ForEach-Object { $_.exercises })
$ids = @($entries | ForEach-Object { $_.id })
$prepEntries = @($prepCatalog.modules | ForEach-Object { $_.exercises })
$prepIds = @($prepEntries | ForEach-Object { $_.id })
$errors = [System.Collections.Generic.List[string]]::new()

function Assert-Course([bool]$Condition, [string]$Message) {
    if (-not $Condition) { $script:errors.Add($Message) }
}

function Assert-DocumentationTargets([string]$Id, [string]$Readme, [object]$Rule) {
    foreach ($target in @($Rule.documentation_targets)) {
        if ($null -ne $target) {
            Assert-Course $Readme.Contains([string]$target) "$Id README must state numeric target: $target"
        }
    }
}

function Assert-ProgressiveHints([string]$Id, [string]$Readme) {
    $hintBlocks = [regex]::Matches($Readme, '(?ms)^## [^\r\n]+ [123]\s*\r?\n(.*?)(?=^## |\z)')
    $emptyHints = @($hintBlocks | Where-Object { $_.Groups[1].Value.Trim().Length -eq 0 })
    Assert-Course ($hintBlocks.Count -eq 3 -and $emptyHints.Count -eq 0) "$Id hints must contain text under every hint heading."
}

function Assert-EnglishLesson([string]$Id, [string]$Readme) {
    Assert-Course ($Readme -match '(?m)^# .+') "$Id English README must contain a title."
    $hintBlocks = [regex]::Matches($Readme, '(?ms)^## Hint [123]\s*\r?\n(.*?)(?=^## |\z)')
    $emptyHints = @($hintBlocks | Where-Object { $_.Groups[1].Value.Trim().Length -eq 0 })
    Assert-Course ($hintBlocks.Count -eq 3 -and $emptyHints.Count -eq 0) "$Id English README must contain three non-empty hints."
}

Assert-Course ($catalog.schema_version -eq 1) 'catalog schema_version must be 1.'
Assert-Course ($checks.schema_version -eq 1) 'checks schema_version must be 1.'
Assert-Course ($prepCatalog.schema_version -eq 1) 'prep catalog schema_version must be 1.'
Assert-Course ($prepChecks.schema_version -eq 1) 'prep checks schema_version must be 1.'
Assert-Course ($catalog.exercise_count -eq 38) 'catalog.exercise_count must be 38.'
Assert-Course ($entries.Count -eq 38) "Expected 38 exercises, found $($entries.Count)."
Assert-Course (@($ids | Sort-Object -Unique).Count -eq 38) 'Exercise IDs must be unique.'

$expectedNumbers = 1..38
$actualNumbers = @($entries | Sort-Object number | ForEach-Object { [int]$_.number })
Assert-Course (($actualNumbers -join ',') -eq ($expectedNumbers -join ',')) 'Exercise numbers must be continuous from 1 through 38.'

$checkIds = @($checks.exercises.PSObject.Properties.Name)
Assert-Course (@(Compare-Object $ids $checkIds).Count -eq 0) 'Validation IDs must match catalog IDs exactly.'

Assert-Course ($prepCatalog.exercise_count -eq 9) 'prep_catalog.exercise_count must be 9.'
Assert-Course ($prepEntries.Count -eq 9) "Expected 9 prep exercises, found $($prepEntries.Count)."
Assert-Course (@($prepIds | Sort-Object -Unique).Count -eq 9) 'Prep exercise IDs must be unique.'
$prepNumbers = 1..9
$actualPrepNumbers = @($prepEntries | Sort-Object number | ForEach-Object { [int]$_.number })
Assert-Course (($actualPrepNumbers -join ',') -eq ($prepNumbers -join ',')) 'Prep exercise numbers must be continuous from 1 through 9.'
$prepCheckIds = @($prepChecks.exercises.PSObject.Properties.Name)
Assert-Course (@(Compare-Object $prepIds $prepCheckIds).Count -eq 0) 'Prep validation IDs must match prep catalog IDs exactly.'

$first = $entries | Sort-Object number | Select-Object -First 1
Assert-Course ([string]::IsNullOrEmpty($first.prerequisite)) 'Exercise 1 must not have a prerequisite.'

foreach ($entry in $entries) {
    $id = [string]$entry.id
    Assert-Course ($id -match '^\d{2}_[a-z0-9_]+$') "Invalid exercise ID: $id"
    if (-not [string]::IsNullOrEmpty($entry.prerequisite)) {
        Assert-Course ($ids -contains $entry.prerequisite) "$id has a missing prerequisite: $($entry.prerequisite)"
        $prerequisite = $entries | Where-Object id -eq $entry.prerequisite | Select-Object -First 1
        Assert-Course ($prerequisite.number -lt $entry.number) "$id must point to an earlier prerequisite."
    }

    $exerciseDir = Join-Path $root "exercises\$id"
    $required = @(
        (Join-Path $exerciseDir 'README.md'),
        (Join-Path $exerciseDir 'exercise.gdshader'),
        (Join-Path $exerciseDir 'starter.gdshader.txt'),
        (Join-Path $root "solutions\$id.gdshader"),
        (Join-Path $exerciseDir 'README.en.md')
    )
    foreach ($path in $required) {
        Assert-Course (Test-Path -LiteralPath $path -PathType Leaf) "Missing file: $path"
    }

    if (Test-Path -LiteralPath $required[0]) {
        $readme = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[0]
        Assert-Course (@([regex]::Matches($readme, '(?m)^## .+\s*$')).Count -ge 5) "$id must contain task, acceptance, and hint sections."
        Assert-Course (@([regex]::Matches($readme, '(?m)^## .+ [123]\s*$')).Count -eq 3) "$id must contain three progressive hints."
        Assert-ProgressiveHints $id $readme
        if ($id -eq 'prep_01_output') {
            Assert-Course ($readme -match 'vec4\(\s*0\.12,\s*0\.78,\s*0\.72,\s*1\.0\)') 'prep_01_output README must state the numeric RGBA target.'
        }
    }

    if (Test-Path -LiteralPath $required[4]) {
        Assert-EnglishLesson $id (Get-Content -Raw -Encoding UTF8 -LiteralPath $required[4])
    }

    if ((Test-Path -LiteralPath $required[2]) -and (Test-Path -LiteralPath $required[3])) {
        $starter = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[2]
        $solution = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[3]
        Assert-Course ($starter -match '(?m)^shader_type\s+(canvas_item|spatial);') "$id starter is missing shader_type."
        Assert-Course ($solution -match '(?m)^shader_type\s+(canvas_item|spatial);') "$id solution is missing shader_type."
        Assert-Course ($starter -ne $solution) "$id starter must differ from its solution."
        if ($id -eq 'prep_01_output') {
            Assert-Course ($solution -match 'vec4\(\s*0\.12,\s*0\.78,\s*0\.72,\s*1\.0\)') 'prep_01_output solution must match the documented numeric RGBA target.'
        }
    }

    $rule = $checks.exercises.PSObject.Properties[$id].Value
    Assert-Course ($rule.mode -eq $entry.validation) "$id catalog validation does not match checks mode."
    if (Test-Path -LiteralPath $required[0]) {
        Assert-DocumentationTargets $id (Get-Content -Raw -Encoding UTF8 -LiteralPath $required[0]) $rule
    }
    foreach ($requirement in @($rule.contracts.required)) {
        if ($null -ne $requirement -and (Test-Path -LiteralPath $required[3])) {
            $solution = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[3]
            Assert-Course ($solution -match $requirement.pattern) "$id solution does not satisfy contract: $($requirement.label)"
        }
    }
}

foreach ($entry in $prepEntries) {
    $id = [string]$entry.id
    Assert-Course ($id -match '^prep_\d{2}_[a-z0-9_]+$') "Invalid prep exercise ID: $id"
    if (-not [string]::IsNullOrEmpty($entry.prerequisite)) {
        Assert-Course ($prepIds -contains $entry.prerequisite) "$id has a missing prep prerequisite: $($entry.prerequisite)"
        $prerequisite = $prepEntries | Where-Object id -eq $entry.prerequisite | Select-Object -First 1
        Assert-Course ($prerequisite.number -lt $entry.number) "$id must point to an earlier prep prerequisite."
    }

    $exerciseDir = Join-Path $root "prep\exercises\$id"
    $required = @(
        (Join-Path $exerciseDir 'README.md'),
        (Join-Path $exerciseDir 'exercise.gdshader'),
        (Join-Path $exerciseDir 'starter.gdshader.txt'),
        (Join-Path $root "prep\solutions\$id.gdshader"),
        (Join-Path $exerciseDir 'README.en.md')
    )
    $rule = $prepChecks.exercises.PSObject.Properties[$id].Value
    Assert-Course ($rule.mode -eq $entry.validation) "$id catalog validation does not match prep checks mode."
    foreach ($path in $required) {
        Assert-Course (Test-Path -LiteralPath $path -PathType Leaf) "Missing prep file: $path"
    }

    if (Test-Path -LiteralPath $required[0]) {
        $readme = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[0]
        Assert-Course (@([regex]::Matches($readme, '(?m)^## .+\s*$')).Count -ge 5) "$id must contain task, acceptance, and hint sections."
        Assert-Course (@([regex]::Matches($readme, '(?m)^## .+ [123]\s*$')).Count -eq 3) "$id must contain three progressive hints."
        Assert-ProgressiveHints $id $readme
        Assert-DocumentationTargets $id $readme $rule
        if ($id -eq 'prep_06_step_smooth') {
            Assert-Course ($readme -match 'vec4\(\s*hard_edge\s*,\s*soft_edge\s*,\s*0\.18\s*,\s*1\.0\s*\)') 'prep_06_step_smooth README must state the complete numeric RGBA target.'
            Assert-Course ($readme -match 'UV\.x\s*=\s*0\.5') 'prep_06_step_smooth README must include a concrete midpoint sample.'
            Assert-Course ($readme -match '\(1\.0,\s*0\.5,\s*0\.18,\s*1\.0\)') 'prep_06_step_smooth README must state the midpoint RGBA value.'
        }
    }

    if (Test-Path -LiteralPath $required[4]) {
        Assert-EnglishLesson $id (Get-Content -Raw -Encoding UTF8 -LiteralPath $required[4])
    }

    if ((Test-Path -LiteralPath $required[2]) -and (Test-Path -LiteralPath $required[3])) {
        $starter = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[2]
        $solution = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[3]
        Assert-Course ($starter -match '(?m)^shader_type\s+(canvas_item|spatial);') "$id starter is missing shader_type."
        Assert-Course ($solution -match '(?m)^shader_type\s+(canvas_item|spatial);') "$id solution is missing shader_type."
        Assert-Course ($starter -ne $solution) "$id starter must differ from its solution."
        if ($id -eq 'prep_06_step_smooth') {
            Assert-Course ($solution -match 'COLOR\s*=\s*vec4\(\s*hard_edge\s*,\s*soft_edge\s*,\s*0\.18\s*,\s*1\.0\s*\)') 'prep_06_step_smooth solution must match the documented numeric RGBA target.'
        }
        foreach ($requirement in @($rule.contracts.required)) {
            if ($null -ne $requirement) {
                Assert-Course ($solution -match $requirement.pattern) "$id solution does not satisfy contract: $($requirement.label)"
            }
        }
    }
}

$prepExerciseDirs = @(Get-ChildItem -LiteralPath (Join-Path $root 'prep\exercises') -Directory | ForEach-Object Name)
Assert-Course (@(Compare-Object $prepIds $prepExerciseDirs).Count -eq 0) 'Prep exercise directories must match prep catalog IDs exactly.'

$exerciseDirs = @(Get-ChildItem -LiteralPath (Join-Path $root 'exercises') -Directory | ForEach-Object Name)
Assert-Course (@(Compare-Object $ids $exerciseDirs).Count -eq 0) 'Exercise directories must match catalog IDs exactly.'
Assert-Course (Test-Path -LiteralPath (Join-Path $root 'shared\shaders\atlas_lighting.gdshaderinc')) 'Missing shared lighting include.'
Assert-Course (Test-Path -LiteralPath (Join-Path $root 'shared\shaders\portal_writer.gdshader')) 'Missing stencil writer shader.'

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Shader Atlas validation passed: $($entries.Count) main exercises, $($prepEntries.Count) prep exercises, $($catalog.modules.Count) modules, all resources and checks present."
