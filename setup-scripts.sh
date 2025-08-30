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

# Function to validate script file for add command
validate_script_file() {
    local script_file="$1"
    
    if [[ ! -f "$script_file" ]]; then
        echo -e "${RED}❌ Error: File '$script_file' not found!${NC}"
        return 1
    fi
    
    return 0
}

# Function to prepare script for add command
prepare_script_file() {
    local source_file="$1"
    local script_name=$(basename "$source_file")
    local target_file="$SCRIPT_DIR/$script_name"
    
    echo -e "${BLUE}📋 Preparing script...${NC}"
    
    # Check if script already exists
    if [[ -f "$target_file" ]] && [[ "$target_file" != "$source_file" ]]; then
        echo -e "${YELLOW}⚠️  Script '$script_name' already exists in repository!${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Operation cancelled.${NC}"
            return 1
        fi
    fi
    
    # Copy script if it's not already in the repository
    if [[ "$target_file" != "$source_file" ]]; then
        cp "$source_file" "$target_file"
        echo -e "${GREEN}✅ Script copied: $script_name${NC}"
    fi
    
    # Make executable
    chmod +x "$target_file"
    echo -e "${GREEN}✅ Script made executable: $script_name${NC}"
    
    return 0
}

# Function to commit and push for add command
commit_and_push() {
    local script_name="$1"
    local commit_message="$2"
    local script_basename=$(basename "$script_name" .sh)
    
    echo -e "${BLUE}🚀 Committing and pushing...${NC}"
    
    # Add files to git
    git add .
    
    # Show what will be committed
    echo -e "${BLUE}📋 Files to be committed:${NC}"
    git diff --cached --name-only
    
    # Check if there are changes to commit
    if ! git diff --cached --quiet; then
        # Commit
        if [[ -n "$commit_message" ]]; then
            git commit -m "feat: Add $script_basename script

$commit_message"
        else
            git commit -m "feat: Add $script_basename script

- Add new script: $script_name
- Made executable and ready to use"
        fi
        
        # Push
        git push
        
        echo -e "${GREEN}✅ Script successfully added to repository and pushed!${NC}"
        echo -e "${BLUE}🌐 Available at: https://github.com/danielfrey63/scripts${NC}"
    else
        echo -e "${YELLOW}ℹ️  No changes to commit.${NC}"
    fi
}

# Function to add new script
add_script() {
    # Check if we're in a git repository
    if [[ ! -d ".git" ]]; then
        echo -e "${RED}❌ Error: Not in a git repository!${NC}"
        echo -e "${YELLOW}Please run this script from the scripts repository directory.${NC}"
        return 1
    fi
    
    # Check arguments
    if [[ $# -lt 2 ]]; then
        echo -e "${RED}❌ Error: Script file required for add command!${NC}"
        echo -e "${YELLOW}Usage: ./setup-scripts.sh add <script-file> [commit-message]${NC}"
        return 1
    fi
    
    local script_file="$2"
    local commit_message="$3"
    
    # Validate input
    if ! validate_script_file "$script_file"; then
        return 1
    fi
    
    # Prepare script
    if ! prepare_script_file "$script_file"; then
        return 1
    fi
    
    local script_name=$(basename "$script_file")
    
    # Get commit message if not provided
    if [[ -z "$commit_message" ]]; then
        echo -e "${BLUE}💬 Enter commit message (or press Enter for default):${NC}"
        read -r commit_message
    fi
    
    # Final confirmation
    echo -e "${BLUE}📋 Summary:${NC}"
    echo -e "  Script: ${GREEN}$script_name${NC}"
    echo -e "  Message: ${GREEN}${commit_message:-Default message}${NC}"
    echo ""
    read -p "Proceed with commit and push? (Y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        commit_and_push "$script_name" "$commit_message"
    else
        echo -e "${YELLOW}Operation cancelled. Script was copied but not committed.${NC}"
    fi
}

# Function to show usage
show_usage() {
    echo -e "${BLUE}🚀 Scripts Repository Management${NC}"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ./setup-scripts.sh install           - Add scripts to PATH"
    echo -e "  ./setup-scripts.sh uninstall         - Remove scripts from PATH"
    echo -e "  ./setup-scripts.sh status            - Show current status"
    echo -e "  ./setup-scripts.sh add <file> [msg]  - Add new script to repository"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo -e "  ./setup-scripts.sh install"
    echo -e "  ./setup-scripts.sh add my-script.sh \"Add useful automation script\""
    echo -e "  ./setup-scripts.sh add /path/to/script.sh"
    echo ""
    echo -e "${BLUE}What this does:${NC}"
    echo -e "• ${GREEN}install${NC}: Adds the scripts directory to your PATH"
    echo -e "• ${GREEN}uninstall${NC}: Removes scripts from PATH"
    echo -e "• ${GREEN}status${NC}: Shows installation status and available scripts"
    echo -e "• ${GREEN}add${NC}: Adds new scripts to repository and pushes to GitHub"
    echo ""
    echo -e "${BLUE}Features:${NC}"
    echo -e "• Automatic shell detection (bash/zsh/etc.)"
    echo -e "• Creates backups before modifications"
    echo -e "• Makes scripts executable automatically"
    echo -e "• Git integration for script management"
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
    add|--add|-a)
        add_script "$@"
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        if [[ $# -eq 0 ]]; then
            show_usage
            echo ""
            read -p "Do you want to install the scripts to your PATH? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                install
            else
                echo -e "${YELLOW}Setup cancelled. Run './setup-scripts.sh install' when ready.${NC}"
            fi
        else
            echo -e "${RED}❌ Unknown command: $1${NC}"
            echo ""
            show_usage
            exit 1
        fi
        ;;
esac
