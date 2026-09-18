$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$SkillSrc = Join-Path $Root ".agents\skills\codex-model-router"
$SkillDst = Join-Path $HOME ".agents\skills\codex-model-router"
$AgentSrc = Join-Path $Root ".codex\agents"
$AgentDst = Join-Path $HOME ".codex\agents"
$CodexDir = Join-Path $HOME ".codex"
$AgentsMd = Join-Path $CodexDir "AGENTS.md"
$Snippet = Join-Path $Root "examples\AGENTS-snippet.md"

New-Item -ItemType Directory -Force -Path (Split-Path -Parent $SkillDst) | Out-Null
New-Item -ItemType Directory -Force -Path $AgentDst | Out-Null
New-Item -ItemType Directory -Force -Path $CodexDir | Out-Null

if (Test-Path $SkillDst) {
    Remove-Item -Recurse -Force $SkillDst
}
Copy-Item -Recurse -Force $SkillSrc $SkillDst

Get-ChildItem -Path $AgentSrc -Filter "cmr-*.toml" | ForEach-Object {
    Copy-Item -Force $_.FullName (Join-Path $AgentDst $_.Name)
}

if (-not (Test-Path $AgentsMd)) {
    New-Item -ItemType File -Path $AgentsMd | Out-Null
}

$Existing = Get-Content -Raw -Path $AgentsMd
if ($Existing -notmatch '<!-- codex-model-router:start -->') {
    Copy-Item -Force $AgentsMd "$AgentsMd.cmr-backup"
    Add-Content -Path $AgentsMd -Value ""
    Add-Content -Path $AgentsMd -Value (Get-Content -Raw -Path $Snippet)
    Add-Content -Path $AgentsMd -Value ""
    Write-Host "Added routing block to $AgentsMd"
} else {
    Write-Host "Routing block already exists in $AgentsMd"
}

Write-Host "Installed codex-model-router."
Write-Host "Skill:  $SkillDst"
Write-Host "Agents: $AgentDst"
Write-Host "Restart Codex if the skill is not detected immediately."
Write-Host "Optional: merge examples\luna-root-config.toml into ~/.codex/config.toml for a cheap parent orchestrator."
