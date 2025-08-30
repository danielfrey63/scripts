#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the absolute path of the scripts directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to detect shell configuration file
detect_shell_config() {
    if [[ "$SHELL" == */zsh* ]]; then
        if [[ -f "$HOME/.zshrc" ]]; then
            echo "$HOME/.zshrc"
        else
            echo "$HOME/.zshrc"
        fi
    elif [[ "$SHELL" == */bash* ]]; then
        if [[ -f "$HOME/.bashrc" ]]; then
            echo "$HOME/.bashrc"
        elif [[ -f "$HOME/.bash_profile" ]]; then
            echo "$HOME/.bash_profile"
        else
            echo "$HOME/.bashrc"
        fi
    else
        echo "$HOME/.profile"
    fi
}

# Function to check if PATH is already added
is_path_added() {
    local config_file="$1"
    if [[ -f "$config_file" ]]; then
        grep -q "export PATH=\"$SCRIPT_DIR:\$PATH\"" "$config_file" 2>/dev/null
    else
        return 1
    fi
}

# Function to install (add to PATH)
install() {
    echo -e "${BLUE}🔧 Installing scripts to PATH...${NC}"
    
    local config_file=$(detect_shell_config)
    echo -e "${YELLOW}Detected shell config: $config_file${NC}"
    
    if is_path_added "$config_file"; then
        echo -e "${YELLOW}⚠️  Scripts directory is already in PATH!${NC}"
        return 0
    fi
    
    # Create backup
    if [[ -f "$config_file" ]]; then
        cp "$config_file" "${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${BLUE}📦 Backup created: ${config_file}.backup.$(date +%Y%m%d_%H%M%S)${NC}"
    fi
    
    # Add to PATH
    echo "" >> "$config_file"
    echo "# Added by scripts repository setup" >> "$config_file"
    echo "export PATH=\"$SCRIPT_DIR:\$PATH\"" >> "$config_file"
    
    # Make all scripts executable
    find "$SCRIPT_DIR" -name "*.sh" -type f -exec chmod +x {} \;
    
    echo -e "${GREEN}✅ Successfully added scripts to PATH!${NC}"
    echo -e "${YELLOW}📝 Please run: source $config_file${NC}"
    echo -e "${YELLOW}   Or restart your terminal to use the scripts.${NC}"
}

# Function to uninstall (remove from PATH)
uninstall() {
    echo -e "${BLUE}🗑️  Removing scripts from PATH...${NC}"
    
    local config_file=$(detect_shell_config)
    
    if ! is_path_added "$config_file"; then
        echo -e "${YELLOW}⚠️  Scripts directory is not in PATH!${NC}"
        return 0
    fi
    
    # Create backup
    cp "$config_file" "${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Remove the PATH addition
    sed -i '/# Added by scripts repository setup/d' "$config_file"
    sed -i "\|export PATH=\"$SCRIPT_DIR:\$PATH\"|d" "$config_file"
    
    echo -e "${GREEN}✅ Successfully removed scripts from PATH!${NC}"
    echo -e "${YELLOW}📝 Please run: source $config_file${NC}"
    echo -e "${YELLOW}   Or restart your terminal.${NC}"
}

# Function to show current status
status() {
    echo -e "${BLUE}📊 Current Status:${NC}"
    echo -e "Scripts directory: ${GREEN}$SCRIPT_DIR${NC}"
    echo -e "Shell: ${GREEN}$SHELL${NC}"
    echo -e "Config file: ${GREEN}$(detect_shell_config)${NC}"
    
    if is_path_added "$(detect_shell_config)"; then
        echo -e "Status: ${GREEN}✅ Installed${NC}"
    else
        echo -e "Status: ${RED}❌ Not installed${NC}"
    fi
    
    echo -e "\n${BLUE}Available scripts:${NC}"
    find "$SCRIPT_DIR" -name "*.sh" -type f -executable | sort | while read script; do
        script_name=$(basename "$script" .sh)
        echo -e "  ${GREEN}• $script_name${NC}"
    done
}

# Main script logic
case "${1:-}" in
    install|--install|-i)
        install
        ;;
    uninstall|--uninstall|-u)
        uninstall
        ;;
    status|--status|-s)
        status
        ;;
    *)
        echo -e "${BLUE}🚀 Scripts Repository Setup${NC}"
        echo ""
        echo -e "${YELLOW}Usage:${NC}"
        echo -e "  ./setup.sh install    - Add scripts to PATH"
        echo -e "  ./setup.sh uninstall  - Remove scripts from PATH"
        echo -e "  ./setup.sh status     - Show current status"
        echo ""
        echo -e "${BLUE}What this does:${NC}"
        echo -e "• Adds the scripts directory to your PATH"
        echo -e "• Makes all .sh files executable"
        echo -e "• Creates backups of your shell config"
        echo -e "• Works with bash, zsh, and other shells"
        echo ""
        read -p "Do you want to install the scripts to your PATH? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install
        else
            echo -e "${YELLOW}Setup cancelled. Run './setup.sh install' when ready.${NC}"
        fi
        ;;
esac
