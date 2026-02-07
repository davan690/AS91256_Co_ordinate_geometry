# Generate Textbook from Lessons
# This script combines all lesson files into a single textbook document

# Load required libraries
library(here)

# Set working directory to project root
setwd(here::here())

# Define paths
lessons_dir <- "lessons"
output_dir <- "drafts"
output_file <- file.path(output_dir, "textbook.qmd")

# Get all lesson files in order
lesson_files <- c(
  "lesson1.qmd",
  "lesson2.qmd",
  "lesson3.qmd",
  "lesson4.qmd",
  "lesson5.qmd",
  "lesson6.qmd"
)

# Create textbook header
textbook_header <- '---
title: "AS91256 Co-ordinate Geometry Textbook"
author: "NZ Curriculum Resources"
date: "`r Sys.Date()`"
format:
  html:
    toc: true
    toc-depth: 3
    number-sections: true
    theme: cosmo
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

'

# Function to read and process a lesson file
process_lesson <- function(lesson_file, lesson_number) {
  filepath <- file.path(lessons_dir, lesson_file)
  
  # Check if file exists
  if (!file.exists(filepath)) {
    warning(paste("File not found:", filepath))
    return(NULL)
  }
  
  # Read the file
  content <- readLines(filepath, warn = FALSE)
  
  # Remove YAML header (between --- markers)
  yaml_start <- which(content == "---")[1]
  yaml_end <- which(content == "---")[2]
  
  if (!is.na(yaml_start) && !is.na(yaml_end)) {
    content <- content[(yaml_end + 1):length(content)]
  }
  
  # Remove empty lines at the start
  while(length(content) > 0 && content[1] == "") {
    content <- content[-1]
  }
  
  # Remove navigation links at the end (lines starting with **Next Lesson:** or similar)
  nav_pattern <- "^(\\*\\*Next Lesson:\\*\\*|---$)"
  nav_lines <- grep(nav_pattern, content)
  if (length(nav_lines) > 0) {
    # Remove from first navigation line to end
    content <- content[1:(nav_lines[1] - 1)]
  }
  
  # Remove trailing empty lines
  while(length(content) > 0 && content[length(content)] == "") {
    content <- content[-length(content)]
  }
  
  # Add page break before each lesson (except the first)
  if (lesson_number > 1) {
    content <- c("\\newpage", "", content)
  }
  
  return(content)
}

# Initialize textbook content
textbook_content <- textbook_header

# Process each lesson
cat("Generating textbook...\n")
for (i in seq_along(lesson_files)) {
  cat(sprintf("Processing %s...\n", lesson_files[i]))
  
  lesson_content <- process_lesson(lesson_files[i], i)
  
  if (!is.null(lesson_content)) {
    # Add the lesson content
    textbook_content <- c(textbook_content, lesson_content, "", "")
  }
}

# Add appendix or closing content
textbook_content <- c(
  textbook_content,
  "\\newpage",
  "",
  "# Appendix",
  "",
  "## Additional Resources",
  "",
  "For additional practice exercises, worked examples, and assessment materials, please refer to the online resources section of this course.",
  "",
  "## Mathematical Formulae Reference",
  "",
  "### Distance Formula",
  "$$d = \\sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2}$$",
  "",
  "### Midpoint Formula",
  "$$M = \\left(\\frac{x_1 + x_2}{2}, \\frac{y_1 + y_2}{2}\\right)$$",
  "",
  "### Gradient (Slope) Formula",
  "$$m = \\frac{y_2 - y_1}{x_2 - x_1}$$",
  "",
  "### Point-Slope Form",
  "$$y - y_1 = m(x - x_1)$$",
  "",
  "### Slope-Intercept Form",
  "$$y = mx + c$$",
  "",
  "### Parallel Lines",
  "Two lines are parallel if they have the same gradient: $m_1 = m_2$",
  "",
  "### Perpendicular Lines",
  "Two lines are perpendicular if the product of their gradients equals -1: $m_1 \\times m_2 = -1$",
  "",
  "## Te Reo Māori Mathematical Vocabulary",
  "",
  "| English | Te Reo Māori |",
  "|---------|--------------|",
  "| Latitude | Ahopae |",
  "| Longitude | Ahopou |",
  "| Map | Mahere |",
  "| Scale | Āwhata |",
  "| North | Raki |",
  "| South | Runga |",
  "| East | Rāwhiti |",
  "| West | Rātō |",
  "| Gradient | Tārewa |",
  "| Distance | Tawhiti |",
  "| Point | Tūnga |",
  "| Line | Rārangi |",
  "",
  "---",
  "",
  "*This textbook was compiled from course materials for AS91256 Co-ordinate Geometry.*"
)

# Write the textbook file
cat(sprintf("Writing textbook to %s...\n", output_file))
writeLines(textbook_content, output_file)

cat("\nTextbook generated successfully!\n")
cat(sprintf("Location: %s\n", output_file))
cat("\nTo render the textbook:\n")
cat("  HTML: quarto render drafts/textbook.qmd --to html\n")
cat("  PDF:  quarto render drafts/textbook.qmd --to pdf\n")
cat("\nOr open in RStudio and click 'Render'\n")

# Optional: Automatically render to HTML
render_html <- readline(prompt = "Would you like to render to HTML now? (y/n): ")
if (tolower(render_html) == "y") {
  cat("\nRendering to HTML...\n")
  system(sprintf("quarto render %s --to html", output_file))
  cat("HTML textbook created!\n")
}
