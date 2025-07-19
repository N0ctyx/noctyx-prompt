#!/bin/bash
# Noctyx Prompt Installer

echo "╔══════════════════════════════╗"
echo "║  NOCTYX HACKER PROMPT SETUP  ║"
echo "╚══════════════════════════════╝"

# Get nickname
read -p "Enter your hacker nickname [default: NIGHTWALKER]: " nickname
[ -z "$nickname" ] && nickname="NIGHTWALKER"

# Copy files
cp noctyx-prompt.sh ~/.noctyx-prompt.sh
echo "export NOCTYX_NICKNAME=\"$nickname\"" >> ~/.bashrc
echo "source ~/.noctyx-prompt.sh" >> ~/.bashrc

# Set permissions
chmod +x ~/.noctyx-prompt.sh

echo ""
echo "Installation complete! Your prompt will activate when you:"
echo "1. Open a new terminal"
echo "2. Or run: source ~/.bashrc"
echo ""
echo "To customize later, edit NOCTYX_NICKNAME in ~/.bashrc"
