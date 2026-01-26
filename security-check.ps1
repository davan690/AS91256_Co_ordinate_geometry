# Security Check Script for AS91256 Co-ordinate Geometry Repository
# Run this script before making the repository public or accepting pull requests

Write-Host "========================================"
Write-Host "  Security Audit for AS91256 Repository"
Write-Host "========================================"
Write-Host ""

$ErrorCount = 0
$WarningCount = 0
$RepoPath = $PSScriptRoot

# Change to repository directory
Set-Location $RepoPath

Write-Host "[INFO] Scanning repository: $RepoPath"
Write-Host ""

# Function to search for patterns
function Search-Pattern {
    param(
        [string]$Pattern,
        [string]$Description
    )
    
    Write-Host "Checking: $Description..." -NoNewline
    
    try {
        $results = git grep -i -E $Pattern 2>$null
        
        if ($results) {
            Write-Host " FOUND (X)" -ForegroundColor Red
            $script:ErrorCount++
            Write-Host "  Matches:" -ForegroundColor Yellow
            $results | ForEach-Object { Write-Host "    $_" -ForegroundColor Yellow }
            return $false
        } else {
            Write-Host " Clean" -ForegroundColor Green
            return $true
        }
    } catch {
        Write-Host " Unable to check" -ForegroundColor Yellow
        $script:WarningCount++
        return $null
    }
}

# Function to check for files
function Check-Files {
    param(
        [string]$Pattern,
        [string]$Description
    )
    
    Write-Host "Checking: $Description..." -NoNewline
    
    $files = git ls-files | Select-String -Pattern $Pattern
    
    if ($files) {
        Write-Host " FOUND (X)" -ForegroundColor Red
        $script:ErrorCount++
        Write-Host "  Files:" -ForegroundColor Yellow
        $files | ForEach-Object { Write-Host "    $_" -ForegroundColor Yellow }
        return $false
    } else {
        Write-Host " Clean" -ForegroundColor Green
        return $true
    }
}

Write-Host "----------------------------------------"
Write-Host "1. API Keys and Tokens"
Write-Host "----------------------------------------"

Search-Pattern "api[_-]?key[s]?\s*[:=]" "API keys"
Search-Pattern "ghp_[a-zA-Z0-9]{36,}" "GitHub personal access tokens"
Search-Pattern "sk_live_[a-zA-Z0-9]{24,}" "Stripe secret keys"
Search-Pattern "access[_-]?token[s]?\s*[:=]" "Access tokens"

Write-Host ""
Write-Host "----------------------------------------"
Write-Host "2. Credentials and Secrets"
Write-Host "----------------------------------------"

Search-Pattern "password\s*[:=]\s*['\x22]?[^\x22'\s]{8,}" "Hardcoded passwords"
Search-Pattern "secret[_-]?key[s]?\s*[:=]" "Secret keys"
Search-Pattern "private[_-]?key[s]?\s*[:=]" "Private keys"
Search-Pattern "aws[_-]?secret[_-]?access[_-]?key" "AWS credentials"

Write-Host ""
Write-Host "----------------------------------------"
Write-Host "3. Personal Information"
Write-Host "----------------------------------------"

Search-Pattern "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "Email addresses"
Search-Pattern "social[_-]?security|ssn|passport" "Sensitive personal data"

Write-Host ""
Write-Host "----------------------------------------"
Write-Host "4. Configuration Files"
Write-Host "----------------------------------------"

Check-Files "\.env$" "Environment files (.env)"
Check-Files "secrets?\.json" "Secret JSON files"
Check-Files "\.pem$|\.key$" "Private key files"

Write-Host ""
Write-Host "----------------------------------------"
Write-Host "5. Database Connections"
Write-Host "----------------------------------------"

Search-Pattern 'mongodb.*://' "MongoDB connection strings"
Search-Pattern 'postgres://' "PostgreSQL connection strings"
Search-Pattern 'mysql://' "MySQL connection strings"

Write-Host ""
Write-Host "----------------------------------------"
Write-Host "6. Git History Check"
Write-Host "----------------------------------------"

Write-Host "Checking recent commits..." -NoNewline
$recentCommits = git log --oneline -10
if ($recentCommits -match "(password|secret|key|token|credential)") {
    Write-Host " Suspicious commit messages found" -ForegroundColor Yellow
    $script:WarningCount++
} else {
    Write-Host " Clean" -ForegroundColor Green
}

Write-Host ""
Write-Host "----------------------------------------"
Write-Host "7. .gitignore Verification"
Write-Host "----------------------------------------"

Write-Host "Checking .gitignore exists..." -NoNewline
if (Test-Path ".gitignore") {
    Write-Host " Found" -ForegroundColor Green
    
    $gitignoreContent = Get-Content ".gitignore" -Raw
    
    Write-Host "Checking .gitignore patterns..." -NoNewline
    $requiredPatterns = @(".env", "_site", ".Renviron")
    $missing = @()
    
    foreach ($pattern in $requiredPatterns) {
        if ($gitignoreContent -notmatch [regex]::Escape($pattern)) {
            $missing += $pattern
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Host " Some patterns missing" -ForegroundColor Yellow
        $script:WarningCount++
        $missingList = $missing -join ", "
        Write-Host "  Consider adding: $missingList" -ForegroundColor Yellow
    } else {
        Write-Host " Good coverage" -ForegroundColor Green
    }
} else {
    Write-Host " Not found" -ForegroundColor Yellow
    $script:WarningCount++
}

Write-Host ""
Write-Host "========================================"
Write-Host "  Audit Complete"
Write-Host "========================================"
Write-Host ""

# Summary
if ($ErrorCount -eq 0 -and $WarningCount -eq 0) {
    Write-Host "PASSED - No security issues found!" -ForegroundColor Green
    Write-Host "Repository is SAFE for public release." -ForegroundColor Green
    exit 0
} elseif ($ErrorCount -eq 0) {
    Write-Host "PASSED WITH WARNINGS - $WarningCount warning(s)" -ForegroundColor Yellow
    Write-Host "Review warnings above before proceeding." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "FAILED - $ErrorCount error(s) found!" -ForegroundColor Red
    Write-Host "$WarningCount warning(s) found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "DO NOT make this repository public until issues are resolved!" -ForegroundColor Red
    exit 1
}
