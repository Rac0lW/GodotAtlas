$ErrorActionPreference = 'Stop'
$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$root = Split-Path -Parent $PSScriptRoot
$catalogPath = Join-Path $root 'course\catalog.json'
$checksPath = Join-Path $root 'course\checks.json'
$catalog = Get-Content -Raw -Encoding UTF8 -LiteralPath $catalogPath | ConvertFrom-Json
$checks = Get-Content -Raw -Encoding UTF8 -LiteralPath $checksPath | ConvertFrom-Json
$entries = @($catalog.modules | ForEach-Object { $_.exercises })
$ids = @($entries | ForEach-Object { $_.id })
$errors = [System.Collections.Generic.List[string]]::new()

function Assert-Course([bool]$Condition, [string]$Message) {
    if (-not $Condition) { $script:errors.Add($Message) }
}

Assert-Course ($catalog.schema_version -eq 1) 'catalog schema_version must be 1.'
Assert-Course ($checks.schema_version -eq 1) 'checks schema_version must be 1.'
Assert-Course ($catalog.exercise_count -eq 32) 'catalog.exercise_count must be 32.'
Assert-Course ($entries.Count -eq 32) "Expected 32 exercises, found $($entries.Count)."
Assert-Course (@($ids | Sort-Object -Unique).Count -eq 32) 'Exercise IDs must be unique.'

$expectedNumbers = 1..32
$actualNumbers = @($entries | Sort-Object number | ForEach-Object { [int]$_.number })
Assert-Course (($actualNumbers -join ',') -eq ($expectedNumbers -join ',')) 'Exercise numbers must be continuous from 1 through 32.'

$checkIds = @($checks.exercises.PSObject.Properties.Name)
Assert-Course (@(Compare-Object $ids $checkIds).Count -eq 0) 'Validation IDs must match catalog IDs exactly.'

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
        (Join-Path $root "solutions\$id.gdshader")
    )
    foreach ($path in $required) {
        Assert-Course (Test-Path -LiteralPath $path -PathType Leaf) "Missing file: $path"
    }

    if (Test-Path -LiteralPath $required[0]) {
        $readme = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[0]
        Assert-Course (@([regex]::Matches($readme, '(?m)^## .+\s*$')).Count -ge 5) "$id must contain task, acceptance, and hint sections."
        Assert-Course (@([regex]::Matches($readme, '(?m)^## .+ [123]\s*$')).Count -eq 3) "$id must contain three progressive hints."
    }

    if ((Test-Path -LiteralPath $required[2]) -and (Test-Path -LiteralPath $required[3])) {
        $starter = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[2]
        $solution = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[3]
        Assert-Course ($starter -match '(?m)^shader_type\s+(canvas_item|spatial);') "$id starter is missing shader_type."
        Assert-Course ($solution -match '(?m)^shader_type\s+(canvas_item|spatial);') "$id solution is missing shader_type."
        Assert-Course ($starter -ne $solution) "$id starter must differ from its solution."
    }

    $rule = $checks.exercises.PSObject.Properties[$id].Value
    Assert-Course ($rule.mode -eq $entry.validation) "$id catalog validation does not match checks mode."
    foreach ($requirement in @($rule.contracts.required)) {
        if ($null -ne $requirement -and (Test-Path -LiteralPath $required[3])) {
            $solution = Get-Content -Raw -Encoding UTF8 -LiteralPath $required[3]
            Assert-Course ($solution -match $requirement.pattern) "$id solution does not satisfy contract: $($requirement.label)"
        }
    }
}

$exerciseDirs = @(Get-ChildItem -LiteralPath (Join-Path $root 'exercises') -Directory | ForEach-Object Name)
Assert-Course (@(Compare-Object $ids $exerciseDirs).Count -eq 0) 'Exercise directories must match catalog IDs exactly.'
Assert-Course (Test-Path -LiteralPath (Join-Path $root 'shared\shaders\atlas_lighting.gdshaderinc')) 'Missing shared lighting include.'
Assert-Course (Test-Path -LiteralPath (Join-Path $root 'shared\shaders\portal_writer.gdshader')) 'Missing stencil writer shader.'

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Shader Atlas validation passed: $($entries.Count) exercises, $($catalog.modules.Count) modules, all resources and checks present."
