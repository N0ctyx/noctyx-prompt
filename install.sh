#!/bin/bash
# Noctyx Hacker Prompt Installer
# License: MIT

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
cat << "EOF"
╔══════════════════════════════╗
║  NOCTYX HACKER PROMPT SETUP  ║
╚══════════════════════════════╝
EOF
echo -e "${NC}"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: Git is required but not installed.${NC}"
    echo -e "Install it with:"
    echo -e "  Ubuntu/Debian: sudo apt install git"
    echo -e "  macOS: brew install git"
    exit 1
fi

# 1. Get User Nickname
echo -e "${YELLOW}>>> Personalize Your Hacker Identity${NC}"
read -p "Enter your hacker nickname [default: NIGHTWALKER]: " nickname
nickname=${nickname:-NIGHTWALKER}

# 2. Install Nerd Fonts (optional)
echo -e "\n${YELLOW}>>> Font Setup (Recommended)${NC}"
read -p "Install Nerd Fonts for icons? [y/N]: " font_choice
if [[ $font_choice =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Installing FiraCode Nerd Font...${NC}"
    
    # Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        mkdir -p ~/.local/share/fonts
        cd ~/.local/share/fonts
        curl -fLo "Fira Code Regular Nerd Font Complete.ttf" \
        "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"
        fc-cache -fv
    # macOS
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew tap homebrew/cask-fonts
        brew install --cask font-fira-code-nerd-font
    fi
fi

# 3. Install Prompt
echo -e "\n${YELLOW}>>> Installing Noctyx Prompt${NC}"
cat > ~/.noctyx-prompt.sh << 'EOF'
#!/bin/bash
# Noctyx Hacker Prompt - Installed Version
[ -z "$NOCTYX_NICKNAME" ] && export NOCTYX_NICKNAME="NIGHTWALKER"

# Color Definitions
NOCTYX_COLOR="\[\e[1;38;5;99m\]"    # Purple
ROOT_COLOR="\[\e[1;38;5;196m\]"     # Red 
DIR_COLOR="\[\e[1;38;5;226m\]"      # Yellow
GIT_COLOR="\[\e[1;38;5;51m\]"       # Cyan
PROMPT_COLOR="\[\e[1;34m\]"         # Blue
RESET="\[\e[0m\]"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

get_threat_level() {
  local rand=$((RANDOM % 6))
  case $rand in
    0) echo "\[\e[1;32m\]■ SAFE${RESET}";;
    1) echo "\[\e[1;36m\]● SCANNING${RESET}";;
    2) echo "\[\e[1;33m\]▲ WARNING${RESET}";;
    3) echo "\[\e[1;31m\]! DANGER${RESET}";;
    4) echo "\[\e[5;31m\]‼ INTRUSION${RESET}";;
    5) echo "\[\e[1;35m\]✧ STEALTH${RESET}";;
  esac
}

__noctyx_prompt() {
  local EXIT="$?"
  [ $EXIT -eq 0 ] && STATUS="\[\e[1;32m\]✔${RESET}" || STATUS="\[\e[1;31m\]✘ \[\e[0;31m\][$EXIT]${RESET}"
  
  if [ "$(id -u)" -eq 0 ]; then
    USER_PROMPT="${ROOT_COLOR}☠ ROOT${RESET}"
  else
    USER_PROMPT="${NOCTYX_COLOR}☠ ${NOCTYX_NICKNAME}${RESET}"
  fi

  local GIT_BRANCH=$(parse_git_branch)
  [ -n "$GIT_BRANCH" ] && GIT="${GIT_COLOR}${GIT_BRANCH}${RESET}" || GIT=""
  local THREAT=$(get_threat_level)

  PS1="${PROMPT_COLOR}┌─[${RESET} ${USER_PROMPT} ${PROMPT_COLOR}]─[${DIR_COLOR}\w${PROMPT_COLOR}]${GIT}─[ ${THREAT} ${PROMPT_COLOR}]\n└─▶ ${RESET}"
}

PROMPT_COMMAND=__noctyx_prompt
EOF

# 4. Add to bashrc
echo -e "\n${YELLOW}>>> Configuring Shell${NC}"
if ! grep -q "noctyx-prompt.sh" ~/.bashrc; then
    echo -e "\n# Noctyx Hacker Prompt" >> ~/.bashrc
    echo "export NOCTYX_NICKNAME=\"$nickname\"" >> ~/.bashrc
    echo "source ~/.noctyx-prompt.sh" >> ~/.bashrc
    echo -e "${GREEN}Added to ~/.bashrc${NC}"
else
    echo -e "${CYAN}Noctyx prompt already exists in ~/.bashrc${NC}"
fi

# 5. Set permissions
chmod +x ~/.noctyx-prompt.sh

# Completion
echo -e "\n${GREEN}✔ Installation Complete!${NC}"
echo -e "Restart your terminal or run:"
echo -e "  ${YELLOW}source ~/.bashrc${NC}\n"

echo -e "Customize later by editing:"
echo -e "  ${CYAN}~/.noctyx-prompt.sh${NC} (prompt colors)"
echo -e "  ${CYAN}~/.bashrc${NC} (nickname: NOCTYX_NICKNAME)"
