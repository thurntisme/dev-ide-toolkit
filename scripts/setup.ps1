param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

Write-Host "=== Dev IDE Toolkit - Setup ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "Available IDEs:"
Write-Host "  1) vscode"
Write-Host "  2) cursor"
Write-Host "  3) kiro-zed"
Write-Host "  4) antigravity"
Write-Host "  5) opencode"
$IdeChoice = Read-Host "Select IDE (1-5)"

switch ($IdeChoice) {
    "1" { $Ide = "vscode" }
    "2" { $Ide = "cursor" }
    "3" { $Ide = "kiro-zed" }
    "4" { $Ide = "antigravity" }
    "5" { $Ide = "opencode" }
    default { Write-Host "Invalid choice" -ForegroundColor Red; exit 1 }
}

Write-Host ""
Write-Host "Available Tech Stacks:"
Write-Host "  1) wordpress"
Write-Host "  2) nextjs"
Write-Host "  3) laravel"
Write-Host "  4) nodejs"
$TechChoice = Read-Host "Select Tech Stack (1-4)"

switch ($TechChoice) {
    "1" { $TechStack = "wordpress" }
    "2" { $TechStack = "nextjs" }
    "3" { $TechStack = "laravel" }
    "4" { $TechStack = "nodejs" }
    default { Write-Host "Invalid choice" -ForegroundColor Red; exit 1 }
}

Write-Host ""
Write-Host "Available Role Profiles:"
Write-Host "  1) fe-dev"
Write-Host "  2) be-dev"
Write-Host "  3) cloud-dev"
$RoleChoice = Read-Host "Select Role Profile (1-3)"

switch ($RoleChoice) {
    "1" { $RoleProfile = "fe-dev" }
    "2" { $RoleProfile = "be-dev" }
    "3" { $RoleProfile = "cloud-dev" }
    default { Write-Host "Invalid choice" -ForegroundColor Red; exit 1 }
}

if ($Ide -eq "opencode") {
    $TargetDir = Join-Path $ProjectPath ".opencode"
    $SharedDir = Join-Path $RootDir "ai-agent\shared"
} else {
    $TargetDir = Join-Path $ProjectPath $Ide
}
$IdeDir = Join-Path $RootDir "ide-configs\$Ide"
$TechStackDir = Join-Path $RootDir "tech-stacks\$TechStack"
$RoleProfileDir = Join-Path $RootDir "role-profiles\$RoleProfile"

if ($Ide -ne "opencode") {
    if (-not (Test-Path $IdeDir)) {
        Write-Host "Error: IDE config not found: $IdeDir" -ForegroundColor Red
        exit 1
    }
}

if (-not (Test-Path $TechStackDir)) {
    Write-Host "Error: Tech stack not found: $TechStackDir" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $RoleProfileDir)) {
    Write-Host "Error: Role profile not found: $RoleProfileDir" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ProjectPath)) {
    Write-Host "Error: Project path not found: $ProjectPath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Copying configs to $TargetDir..."

New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null

if ($Ide -eq "opencode") {
    Copy-Item -Recurse -Path "$SharedDir\*" -Destination "$TargetDir\"
    Write-Host "  [OK] ai-agent (.opencode)" -ForegroundColor Green
} else {
    Copy-Item -Recurse -Path "$IdeDir\*" -Destination "$TargetDir\"
    Write-Host "  [OK] IDE config: $Ide" -ForegroundColor Green
}

New-Item -ItemType Directory -Path "$TargetDir\tech-stack" -Force | Out-Null
Copy-Item -Recurse -Path "$TechStackDir\*" -Destination "$TargetDir\tech-stack\"
Write-Host "  [OK] Tech stack: $TechStack" -ForegroundColor Green

New-Item -ItemType Directory -Path "$TargetDir\role-profile" -Force | Out-Null
Copy-Item -Recurse -Path "$RoleProfileDir\*" -Destination "$TargetDir\role-profile\"
Write-Host "  [OK] Role profile: $RoleProfile" -ForegroundColor Green

Write-Host ""
Write-Host "Done! Project structure:" -ForegroundColor Green
Write-Host "  $TargetDir\"
if ($Ide -eq "opencode") {
    Write-Host "    * .opencode\" -ForegroundColor Gray
} else {
    Write-Host "    * (IDE config files)" -ForegroundColor Gray
}
Write-Host "    * tech-stack\" -ForegroundColor Gray
Write-Host "    * role-profile\" -ForegroundColor Gray
