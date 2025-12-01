#!/bin/bash

# Laravel Docker Project Installer
# This script downloads the necessary files from the laravel-docker project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base URL for the GitHub repository
REPO_URL="https://raw.githubusercontent.com/lorenzocattaneo/laravel-docker/main"

echo -e "${GREEN}🐳 Laravel Docker Installer${NC}"
echo "======================================"
echo ""

download_file() {
  local url="$1"
  local output="$2"
  local description="$3"

  if curl -fsSL "$url" -o "$output"; then
    echo -e "${GREEN}✅ Downloaded: $output${NC}"
  else
    echo -e "${RED}❌ Failed to download: $output${NC}"
    echo -e "${RED}   URL: $url${NC}"
    exit 1
  fi
}

ensure_directory() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    echo -e "📁 Creating directory: $dir"
    mkdir -p "$dir"
  fi
}

echo "🚀 Starting installation process..."
echo ""

download_file "$REPO_URL/user-project-files/.dockerignore" ".dockerignore"
download_file "$REPO_URL/user-project-files/compose.yaml" "compose.yaml"
download_file "$REPO_URL/user-project-files/Makefile" "Makefile"
download_file "$REPO_URL/user-project-files/Dockerfile" "Dockerfile"

ensure_directory ".devcontainer"
download_file "$REPO_URL/user-project-files/devcontainer.json" ".devcontainer/devcontainer.json"
ensure_directory ".docker/dev/supervisor"
download_file "$REPO_URL/user-project-files/custom-supervisor-example.conf" ".docker/dev/supervisor/laravel-dev.conf"
ensure_directory ".docker/dev/php"
download_file "$REPO_URL/user-project-files/custom-php-conf-example.ini" ".docker/dev/php/custom-00.ini"

echo ""
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo ""
echo -e "${YELLOW}📖 Next steps:${NC}"
echo "1. Review and customize the downloaded files for your project"
echo "2. Check the project documentation at: https://github.com/lorenzocattaneo/laravel-docker"
echo "3. Run 'make d.run' to start your Laravel development environment"
echo "4. The project is ready. If your editor supports it, a devcontainer configuration has been set up."
echo ""

# Delete the install script
rm -f "$0"
