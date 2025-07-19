#!/bin/bash
# Noctyx Prompt Remover

sed -i '/NOCTYX_NICKNAME/d' ~/.bashrc
sed -i '/noctyx-prompt.sh/d' ~/.bashrc
rm -f ~/.noctyx-prompt.sh

echo "Noctyx Hacker Prompt removed. Restart your terminal."
