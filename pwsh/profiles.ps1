# ============================================================================
# PowerShell Profile - Fully Optimized
# Location: $PROFILE
# ============================================================================

# Measure profile load time
$profileStart = Get-Date

# ============================================================================
# OPTIMIZATION: Cache directory for generated init scripts
# ============================================================================
$cacheDir = "$env:TEMP\PSProfileCache"
if (-not (Test-Path $cacheDir)) {
  New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
}

# ============================================================================
# MODULES - Fast import with error handling
# ============================================================================
$modules = @{
  "PSReadLine" = $true
    "Terminal-Icons" = $true
    "PSFzf" = $true
}

foreach ($module in $modules.Keys) {
  try {
    Import-Module $module -ErrorAction Stop
  }
  catch {
    Write-Warning "Failed to load $module : $_"
      $modules[$module] = $false
  }
}

# ============================================================================
# PSREADLINE - Fast configuration
# ============================================================================
if ($modules["PSReadLine"]) {
  $psroptions = @{
    PredictionSource = "History"
      PredictionViewStyle = "ListView"
      EditMode = "Windows"
      Colors = @{
        Command = 'Yellow'
          Parameter = 'Green'
          String = 'DarkCyan'
          Number = 'Magenta'
      }
  }
  Set-PSReadLineOption @psroptions
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
    Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord
}

# ============================================================================
# PSFZF - Single configuration call
# ============================================================================
if ($modules["PSFzf"]) {
  Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Alt+c' -Force
}

# ============================================================================
# STARSHIP - Cached initialization with timeout fix
# ============================================================================
$env:STARSHIP_SCAN_TIMEOUT = 2000
$starshipCache = "$cacheDir\starship_init.ps1"

try {
  if ((Test-Path $starshipCache) -and ((Get-Item $starshipCache).LastWriteTime -gt (Get-Date).AddDays(-7))) {
    . $starshipCache
  }
  else {
    starship init powershell | Out-String | Set-Content $starshipCache -Encoding UTF8
      . $starshipCache
  }
}
catch {
  Write-Warning "Starship initialization failed: $_"
}

# ============================================================================
# ZOXIDE - Cached initialization
# ============================================================================
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
  $zoxideCache = "$cacheDir\zoxide_init.ps1"
    try {
      if ((Test-Path $zoxideCache) -and ((Get-Item $zoxideCache).LastWriteTime -gt (Get-Date).AddDays(-7))) {
        . $zoxideCache
      }
      else {
        zoxide init powershell | Out-String | Set-Content $zoxideCache -Encoding UTF8
          . $zoxideCache
      }
    }
  catch {
    Write-Warning "Zoxide initialization failed: $_"
  }
}

# ============================================================================
# ALIASES & FUNCTIONS
# ============================================================================

# Editor aliases
Set-Alias vi nvim -ErrorAction SilentlyContinue
Set-Alias vim nvim -ErrorAction SilentlyContinue
Set-Alias c Clear-Host
Set-Alias ff fastfetch

# Navigation shortcuts (functions are faster than ${function:} syntax)
function ~ { Set-Location ~ }
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }
function ...... { Set-Location ..\..\..\..\.. }

# Quick folder shortcuts
function dt { Set-Location ~\Desktop }
function docs { Set-Location ~\Documents }
function dl { Set-Location ~\Downloads }
function drop { Set-Location ~\AppData\Roaming }
function prog { Set-Location 'C:\Program Files' }
function prog86 { Set-Location 'C:\Program Files (x86)' }

# ============================================================================
# ENHANCED LS - Auto-detect best available tool
# ============================================================================
if (Get-Command eza -ErrorAction SilentlyContinue) {
# EZA is faster and more feature-rich
  function ll { eza -la --icons --git --group-directories-first }
  function la { eza -a --icons --group-directories-first }
  function lt { eza -T -L 2 --icons --group-directories-first }
  function l { eza --icons --group-directories-first }
}
elseif ($modules["Terminal-Icons"]) {
# Fallback to Terminal-Icons
  function ll { Get-ChildItem -Force | Format-Wide -Property Name -AutoSize -Force }
  function la { Get-ChildItem -Force -Hidden }
  function lt { Get-ChildItem -Directory }
  function l { Get-ChildItem }
}
else {
# Minimal fallback
  function ll { Get-ChildItem -Force }
  function la { Get-ChildItem -Force -Hidden }
  function lt { Get-ChildItem -Directory }
  function l { Get-ChildItem }
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

function touch {
  param($file)
    if (Test-Path $file) {
      (Get-Item $file).LastWriteTime = Get-Date
    }
    else {
      New-Item -ItemType File -Path $file -Force | Out-Null
    }
}

function which {
  param($command)
    Get-Command $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

function mkcd {
  param($path)
    New-Item -ItemType Directory -Path $path -Force -ErrorAction SilentlyContinue | Out-Null
    Set-Location $path
}

# ============================================================================
# YAZI - Terminal file manager with proper cleanup
# ============================================================================
function y {
  $tmp = [System.IO.Path]::GetTempFileName()
    try {
      yazi $args --cwd-file="$tmp"
        if (Test-Path $tmp) {
          $cwd = Get-Content -Path $tmp -Encoding UTF8 -Raw
            if (-not [String]::IsNullOrWhiteSpace($cwd) -and $cwd.Trim() -ne $PWD.Path) {
              Set-Location $cwd.Trim()
            }
        }
    }
  finally {
    Remove-Item -Path $tmp -ErrorAction SilentlyContinue
  }
}

# ============================================================================
# PROFILE MANAGEMENT - Using approved verbs
# ============================================================================
function Edit-Profile { 
  nvim $PROFILE.CurrentUserAllHosts
}

function Update-Profile { 
  . $PROFILE.CurrentUserAllHosts
    Write-Host "✓ Profile reloaded" -ForegroundColor Green
}

# Optional: Keep common aliases for convenience
Set-Alias -Name ep -Value Edit-Profile
Set-Alias -Name reload -Value Update-Profile
Set-Alias -Name refresh -Value Update-Profile

# ============================================================================
# TOOLCHAIN - Optimized definitions
# ============================================================================
$MyTools = @(
    "nvim", "fzf", "zoxide", "rg", "fd", "bat", "eza", "yazi",
    "git", "gh", "lazygit", "lazydocker",
    "lua", "python", "node", "go", "rustc", "gcc", "make",
    "pandoc", "miktex", "sumatrapdf", "mpv", "ffmpeg", "yt-dlp",
    "jq", "lua-language-server", "stylua", "shellcheck", "ani-cli"
    )

function checksh {
  Write-Host "`n=== 🧠 Toolchain Check ===`n" -ForegroundColor Cyan

    $aliasMap = @{ "neovim" = "nvim"; "ripgrep" = "rg" }
  $match = 0
    $missing = 0

    foreach ($tool in $MyTools) {
      $exeName = if ($aliasMap.ContainsKey($tool)) { $aliasMap[$tool] } else { $tool }
      $cmd = Get-Command $exeName -ErrorAction SilentlyContinue

        if ($cmd) {
          if (Get-Command scoop -ErrorAction SilentlyContinue) {
            $scoopOutput = scoop list 2>$null
              if ($scoopOutput | Select-String $tool) { 
                "scoop" 
              } else { 
                "system" 
              }
          } else { 
            "system" 
          }
        }
        else {
          Write-Host ("  ✗ {0,-18} → NOT FOUND" -f $tool) -ForegroundColor Red
            $missing++
        }
    }

  Write-Host "`n  Available: $match  |  Missing: $missing" -ForegroundColor $(if ($missing -eq 0) { "Green" } else { "Yellow" })
}

function checkdup {
  Write-Host "`n=== 🔍 Duplicate Detection ===`n" -ForegroundColor Cyan

    foreach ($tool in $MyTools) {
      $cmds = Get-Command $tool -All -ErrorAction SilentlyContinue
        if ($cmds.Count -le 1) { continue }

      $paths = $cmds.Source | Select-Object -Unique
        if ($paths.Count -gt 1) {
          Write-Host "  ⚠ $tool ($($paths.Count) copies):" -ForegroundColor Yellow
            $paths | ForEach-Object { Write-Host "      $_" -ForegroundColor Gray }
        }
    }
  Write-Host ""
}

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================
$env:EDITOR = "nvim"
$env:FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --info=inline"
$env:BAT_THEME = "Catppuccin-mocha"

# ============================================================================
# LOAD TIME DISPLAY
# ============================================================================
  $profileTime = (Get-Date) - $profileStart
$profileTimeMs = [math]::Round($profileTime.TotalMilliseconds)

  if ($profileTimeMs -gt 3000) {
    Write-Host "⚠️  Profile: ${profileTimeMs}ms (consider reviewing)" -ForegroundColor Yellow
  }
elseif ($profileTimeMs -gt 2000) {
  Write-Host "⚡ Profile: ${profileTimeMs}ms (good)" -ForegroundColor Cyan
}
else {
  Write-Host "🚀 Profile: ${profileTimeMs}ms (excellent!)" -ForegroundColor Green
}

# Clean up cache directory variable (no longer needed)
Remove-Variable cacheDir -ErrorAction SilentlyContinue
$env:YAZI_CONFIG_HOME = "$env:APPDATA\yazi"
