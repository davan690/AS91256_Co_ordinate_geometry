# Generate Textbook - PowerShell Version
# This script combines all lesson files into a single textbook document

Write-Host "Generating textbook..." -ForegroundColor Green

# Define paths
$lessonsDir = "lessons"
$outputDir = "drafts"
$outputFile = Join-Path $outputDir "textbook.qmd"

# Ensure we're in the project root
Set-Location $PSScriptRoot\..

# Get all lesson files in order
$lessonFiles = @(
    "lesson1.qmd",
    "lesson2.qmd",
    "lesson3.qmd",
    "lesson4.qmd",
    "lesson5.qmd",
    "lesson6.qmd"
)

# Create textbook header
$textbookHeader = @"
---
title: "AS91256 Co-ordinate Geometry Textbook"
author: "NZ Curriculum Resources"
date: "$(Get-Date -Format 'MMMM dd, yyyy')"
format:
  html:
    toc: true
    toc-depth: 3
    number-sections: true
    theme: cosmo
    embed-resources: true
  pdf:
    toc: true
    number-sections: true
    geometry: margin=1in
    documentclass: book
---

# Preface

This textbook provides a comprehensive guide to coordinate geometry for AS91256. The content is organized into progressive lessons covering fundamental concepts through to advanced applications.

## About This Course

This course explores coordinate geometry through practical applications and real-world contexts. Students will develop skills in:

- Understanding and using the Cartesian coordinate system
- Working with map scales, coordinates, and bearings
- Calculating distances and midpoints
- Analyzing gradients and linear equations
- Understanding parallel and perpendicular lines

## How to Use This Textbook

Each lesson includes:
- Clear learning objectives
- Worked examples with step-by-step solutions
- Practice exercises with varying difficulty
- Real-world applications and contexts
- Cultural connections and te reo Māori vocabulary where relevant

---

"@

# Initialize content array
$content = @()
$content += $textbookHeader

# Process each lesson
$lessonNumber = 1
foreach ($lessonFile in $lessonFiles) {
    $filepath = Join-Path $lessonsDir $lessonFile
    
    Write-Host "Processing $lessonFile..." -ForegroundColor Cyan
    
    if (Test-Path $filepath) {
        # Read the file
        $lines = Get-Content $filepath -Encoding UTF8
        
        # Remove YAML header (between --- markers)
        $yamlStart = -1
        $yamlEnd = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -eq "---") {
                if ($yamlStart -eq -1) {
                    $yamlStart = $i
                } elseif ($yamlEnd -eq -1) {
                    $yamlEnd = $i
                    break
                }
            }
        }
        
        if ($yamlEnd -gt $yamlStart -and $yamlStart -ge 0) {
            $lessonContent = $lines[($yamlEnd + 1)..($lines.Count - 1)]
        } else {
            $lessonContent = $lines
        }
        
        # Remove empty lines at the start
        while ($lessonContent.Count -gt 0 -and [string]::IsNullOrWhiteSpace($lessonContent[0])) {
            $lessonContent = $lessonContent[1..($lessonContent.Count - 1)]
        }
        
        # Remove navigation links at the end
        $lastContent = $lessonContent.Count - 1
        for ($i = $lessonContent.Count - 1; $i -ge 0; $i--) {
            if ($lessonContent[$i] -match "^\*\*Next Lesson:\*\*|^---$") {
                $lastContent = $i - 1
                break
            }
        }
        if ($lastContent -lt $lessonContent.Count - 1) {
            $lessonContent = $lessonContent[0..$lastContent]
        }
        
        # Remove trailing empty lines
        while ($lessonContent.Count -gt 0 -and [string]::IsNullOrWhiteSpace($lessonContent[$lessonContent.Count - 1])) {
            $lessonContent = $lessonContent[0..($lessonContent.Count - 2)]
        }
        
        # Add page break before each lesson (except the first)
        if ($lessonNumber -gt 1) {
            $content += ""
            $content += "\newpage"
            $content += ""
        }
        
        # Add the lesson content
        $content += $lessonContent
        $content += ""
        
        $lessonNumber++
    } else {
        Write-Warning "File not found: $filepath"
    }
}

# Add appendix
$appendix = @"

\newpage

# Appendix

## Additional Resources

For additional practice exercises, worked examples, and assessment materials, please refer to the online resources section of this course.

## Mathematical Formulae Reference

### Distance Formula
`$`$d = \sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}`$`$

### Midpoint Formula
`$`$M = \left(\frac{x_1 + x_2}{2}, \frac{y_1 + y_2}{2}\right)`$`$

### Gradient (Slope) Formula
`$`$m = \frac{y_2 - y_1}{x_2 - x_1}`$`$

### Point-Slope Form
`$`$y - y_1 = m(x - x_1)`$`$

### Slope-Intercept Form
`$`$y = mx + c`$`$

### Parallel Lines
Two lines are parallel if they have the same gradient: `$m_1 = m_2`$

### Perpendicular Lines
Two lines are perpendicular if the product of their gradients equals -1: `$m_1 \times m_2 = -1`$

## Te Reo Māori Mathematical Vocabulary

| English | Te Reo Māori |
|---------|--------------|
| Latitude | Ahopae |
| Longitude | Ahopou |
| Map | Mahere |
| Scale | Āwhata |
| North | Raki |
| South | Runga |
| East | Rāwhiti |
| West | Rātō |
| Gradient | Tārewa |
| Distance | Tawhiti |
| Point | Tūnga |
| Line | Rārangi |

---

*This textbook was compiled from course materials for AS91256 Co-ordinate Geometry.*
"@

$content += $appendix

# Write the textbook file
Write-Host "`nWriting textbook to $outputFile..." -ForegroundColor Green
$content | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "`nTextbook generated successfully!" -ForegroundColor Green
Write-Host "Location: $outputFile" -ForegroundColor Yellow
Write-Host "`nTo render the textbook:" -ForegroundColor Cyan
Write-Host "  HTML: quarto render drafts/textbook.qmd --to html" -ForegroundColor White
Write-Host "  PDF:  quarto render drafts/textbook.qmd --to pdf" -ForegroundColor White
Write-Host "`nOr open drafts/textbook.qmd in RStudio and click 'Render'" -ForegroundColor White
