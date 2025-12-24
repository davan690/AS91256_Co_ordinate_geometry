# AS91256 Co-ordinate Geometry

Resources and content for teaching co-ordinate geometry at year 11. Three week course. Assessment is Level 2 NCEA. Two credits.

## About

This is a Quarto website project that provides comprehensive teaching materials for AS91256 - Apply co-ordinate geometry methods in solving problems. The website includes:

- **Lessons**: Three structured lesson plans covering the core concepts
- **Resources**: Worksheets and worked examples for practice
- **Assessment**: Information about the NCEA standard and preparation guidance

## 🌐 Viewing the Website

The website is automatically built and deployed via GitHub Actions. Once set up, you can view it at:
```
https://[your-username].github.io/AS91256_Co_ordinate_geometry/
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

## 🚀 GitHub Actions Setup

The repository includes a GitHub Actions workflow that automatically builds and deploys the website to GitHub Pages.

### Initial Setup

1. **Enable GitHub Pages**:
   - Go to your repository on GitHub
   - Navigate to **Settings** → **Pages**
   - Under "Build and deployment", select **Source**: "GitHub Actions"

2. **Push to main branch**:
   - The workflow automatically triggers on pushes to the `main` branch
   - You can also manually trigger it from the "Actions" tab

### How GitHub Actions Works

The workflow (`.github/workflows/publish.yml`) performs the following steps:

1. **Checkout**: Gets the repository code
2. **Setup Quarto**: Installs Quarto on the runner
3. **Setup R**: Installs R for RMarkdown support
4. **Install Dependencies**: Installs necessary R packages
5. **Render**: Builds the Quarto website
6. **Upload**: Prepares the built site as an artifact
7. **Deploy**: Publishes to GitHub Pages

### Manual Workflow Trigger

You can manually trigger the build:
1. Go to the **Actions** tab in your GitHub repository
2. Select the "Publish Quarto Website" workflow
3. Click **Run workflow** → **Run workflow**

### Monitoring Builds

- View build status in the **Actions** tab
- Green checkmark ✓ indicates successful build
- Red X ✗ indicates build failure (click to see logs)

### Common Issues

**Build Fails**: 
- Check the Actions logs for specific error messages
- Ensure all `.qmd` files have valid YAML frontmatter
- Verify there are no broken links in the content

**Pages Not Updating**:
- Wait a few minutes after the workflow completes
- Clear your browser cache
- Check that GitHub Pages is configured correctly

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
