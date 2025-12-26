# Sandeep Lamba - Personal Blog

A modern, responsive Jekyll-based personal blog showcasing cloud and DevOps content, built with the Mediumish theme.

[![Jekyll](https://img.shields.io/badge/jekyll-4.3-blue.svg)](https://jekyllrb.com/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Ruby](https://img.shields.io/badge/ruby-3.4+-red.svg)](https://www.ruby-lang.org/)

## 🌐 Live Site

Visit the live blog at: **[https://sandeeplamb.github.io](https://sandeeplamb.github.io)**

## 📋 Table of Contents

- [About](#about)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Configuration](#configuration)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## About

This is a personal blog built with Jekyll, focusing on cloud technologies, DevOps practices, Kubernetes, and related topics. The site uses the [Mediumish Jekyll theme](https://github.com/wowthemesnet/mediumish-theme-jekyll) as its foundation, customized for personal use.

## Features

- ✨ **Modern Design**: Clean, responsive layout inspired by Medium
- 📱 **Mobile Responsive**: Optimized for all device sizes
- 🔍 **Search Functionality**: Built-in search using Lunr.js
- 📝 **Syntax Highlighting**: Code syntax highlighting with Rouge
- 🏷️ **Categories & Tags**: Organized content with categories and tags
- 📊 **SEO Optimized**: Built-in SEO tags and sitemap generation
- 🎨 **Lazy Loading**: Optimized image loading for better performance
- 📄 **Pagination**: Easy navigation through blog posts
- 💬 **Disqus Integration**: Ready for comment system integration
- 📧 **RSS Feed**: Automatic RSS feed generation

## Prerequisites

Before you begin, ensure you have the following installed:

- **Ruby** (3.4 or higher)
- **Bundler** gem
- **Git**

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sandeeplamb/sandeeplamb.github.io.git
   cd sandeeplamb.github.io
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Run Jekyll locally**
   ```bash
   bundle exec jekyll serve
   ```

4. **View the site**
   Open your browser and navigate to `http://localhost:4000`

## Usage

### Creating a New Post

1. Create a new markdown file in the `_posts/` directory
2. Use the following naming convention: `YYYY-MM-DD-post-title.md`
3. Add front matter at the top of the file:

```yaml
---
layout: post
title: "Your Post Title"
author: Sandeep
categories: [category1, category2]
tags: [tag1, tag2]
image: assets/images/your-image.jpg
---
```

### Running Locally

```bash
# Start the development server
bundle exec jekyll serve

# Build the site
bundle exec jekyll build

# Serve with drafts
bundle exec jekyll serve --drafts
```

### Docker Support

The project includes Docker support for easy deployment:

```bash
# Build and run with Docker Compose
docker-compose up

# Or use the provided script
./docker/run.sh
```

## Project Structure

```
.
├── _config.yml          # Jekyll configuration
├── _includes/           # Reusable HTML components
├── _layouts/            # Page templates
├── _pages/              # Static pages
├── _posts/              # Blog posts
├── _sass/               # SCSS stylesheets
├── assets/              # Images, CSS, JS, and other assets
├── Gemfile              # Ruby dependencies
└── docker/              # Docker configuration files
```

## Configuration

Key configuration options in `_config.yml`:

- **Site Information**: Name, title, description, URL
- **Author Details**: Name, email, social media links
- **Plugins**: Jekyll plugins configuration
- **Pagination**: Number of posts per page
- **SEO**: Twitter cards, analytics, and more

For detailed configuration options, refer to the [Jekyll documentation](https://jekyllrb.com/docs/configuration/).

## Development

### Adding New Features

1. Create a feature branch
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and test locally

3. Commit your changes
   ```bash
   git commit -m "Add: description of your feature"
   ```

4. Push to the branch
   ```bash
   git push origin feature/your-feature-name
   ```

5. Open a Pull Request

### Code Style

- Follow Jekyll best practices
- Use meaningful commit messages
- Test changes locally before pushing

## Contributing

Contributions are welcome! If you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

Please ensure your code follows the existing style and includes appropriate tests/documentation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Note**: This site uses the [Mediumish Jekyll theme](https://github.com/wowthemesnet/mediumish-theme-jekyll) by [Sal](https://www.wowthemes.net), which is also licensed under MIT.

## Acknowledgments

- **Mediumish Theme**: Designed and developed by [Sal](https://www.wowthemes.net)
- **Jekyll**: Static site generator
- **Bootstrap**: CSS framework
- **Highlight.js**: Syntax highlighting
- **Lunr.js**: Client-side search

### Resources

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [Mediumish Theme Demo](https://wowthemesnet.github.io/mediumish-theme-jekyll/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)
- [Highlight.js Demo](https://highlightjs.org/static/demo/)

---

**Built with ❤️ by Sandeep Lamba**

For questions or suggestions, feel free to reach out via [Twitter](https://twitter.com/sandeeplamb) or open an issue.
