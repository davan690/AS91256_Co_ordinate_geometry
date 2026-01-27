# AS91256 Co-ordinate Geometry

Resources and content for teaching co-ordinate geometry at year 11. Three week course. Assessment is Level 2 NCEA. Two credits.

## About

This is a Quarto website project that provides comprehensive teaching materials for AS91256 - Apply co-ordinate geometry methods in solving problems. The website includes:

- **Lessons**: Three structured lesson plans covering the core concepts
- 
- **Resources**: Worksheets and worked examples for practice

- **Assessment**: Information about the NCEA standard and preparation guidance

## 🌐 Viewing the Website

The website is automatically built and deployed via GitHub Actions. Once set up, you can view it at:
```

https://davan690.github.io/AS91256_Co_ordinate_geometry/
```

## 🛠️ Local Development

### Prerequisites

1. **Install Quarto**: Download and install from [quarto.org](https://quarto.org/docs/get-started/)
2. **Install R** (optional, for RMarkdown support): Download from [r-project.org](https://www.r-project.org/)

### Building Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/davan690/AS91256_Co_ordinate_geometry.git
   cd AS91256_Co_ordinate_geometry
   ```

2. Preview the website:
   ```bash
   quarto preview
   ```
   This will start a local server and open the website in your browser.

3. Build the website:
   ```bash
   quarto render
   ```
   The rendered site will be in the `_site` directory.

## 🚀 GitHub Pages Deployment

This repository hosts pre-built HTML files directly from the `docs/` folder - no build process needed on GitHub!

### Setup Instructions

1. **Build Locally**:
   ```bash
   quarto render
   ```
   This generates static HTML files in the `docs/` folder.

2. **Commit and Push**:
   ```bash
   git add docs/
   git commit -m "Update website content"
   git push
   ```

3. **Configure GitHub Pages** (one-time setup):
   - Go to your repository on GitHub
   - Navigate to **Settings** → **Pages**
   - Under "Build and deployment":
     - **Source**: Select "Deploy from a branch"
     - **Branch**: Select "main" and folder "/docs"
     - Click **Save**

4. **View Your Site**:
   - After a few moments, your site will be live at:
   - https://davan690.github.io/AS91256_Co_ordinate_geometry/

### Updating the Website

1. Make changes to `.qmd` files
2. Run `quarto render` locally
3. Commit the updated `docs/` folder
4. Push to GitHub
5. Site updates automatically!

### Benefits

- ✅ No GitHub Actions build time
- ✅ No cost for build minutes
- ✅ Faster deployment (just commits)
- ✅ See exact output before pushing
- ✅ Simple and reliable

### Note

The `.github/workflows/publish.yml` file is no longer needed and can be deleted or ignored.

## 📝 Content Structure

```
AS91256_Co_ordinate_geometry/
├── _quarto.yml              # Quarto configuration
├── index.qmd                # Homepage
├── styles.css               # Custom styling
├── lessons/                 # Lesson content
│   ├── index.qmd
│   ├── lesson1.qmd
│   ├── lesson2.qmd
│   └── lesson3.qmd
├── resources/               # Additional resources
│   ├── index.qmd
│   ├── worksheets.qmd
│   └── examples.qmd
├── assessment/              # Assessment information
│   └── index.qmd
└── .github/
    └── workflows/
        └── publish.yml      # GitHub Actions workflow
```

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a new branch for your changes
3. Make your modifications
4. Test locally with `quarto preview`
5. Submit a pull request

## 📄 License

Educational materials provided for teaching purposes.

## 📧 Contact

For questions or suggestions, please open an issue on GitHub.
