#!/bin/bash
set -e

# Install ralph-setup command globally
# This creates a symlink in /usr/local/bin

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/ralph-orchestrator-template"
INSTALL_DIR="/usr/local/bin"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing ralph-setup...${NC}"

# Create wrapper script that calls setup.sh with correct path
cat > "$INSTALL_DIR/ralph-setup" << EOF
#!/bin/bash
exec "$TEMPLATE_DIR/setup.sh" "\$@"
EOF

chmod +x "$INSTALL_DIR/ralph-setup"

echo -e "${GREEN}Installed: ralph-setup${NC}"
echo ""
echo "Usage:"
echo "  ralph-setup ~/devel/my-project \"Project description here\""
echo "  ralph-setup ~/devel/my-project  # Interactive mode"
