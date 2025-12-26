# github Mediumish Jekyll Theme - Change Log

## 2024-12-19
- Upgraded to Jekyll 4.3+ for Ruby 3.4+ compatibility
- Replaced github-pages gem with modern Jekyll and plugin versions
- Added explicit dependencies for Ruby 3.4+ (csv, bigdecimal, logger, rexml)
- Updated all Jekyll plugins to latest compatible versions
- Added .ruby-version file (3.4.0)
- Configured bundle to force Ruby platform compilation for native extensions
- Fixed ffi gem compatibility issue with Ruby 3.4.0 on macOS
- Added Docker setup for local development
- Created `docker/` folder with docker-compose.yml and run.sh script
- Added run.sh script to easily start Jekyll site locally
- Site accessible at http://localhost:4000 when running locally

## 2020-07-13, v1.0.0
- Initial Release
