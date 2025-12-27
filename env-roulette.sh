#!/usr/bin/env bash
# Environment Variable Roulette - Because debugging should feel like gambling!
# Spin the wheel and see whose environment is the weirdest.

# Colors for maximum dramatic effect
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# The main event - compare env vars across systems
compare_env() {
    echo -e "${CYAN}🎰 Spinning the Environment Roulette Wheel...${NC}"
    echo -e "${YELLOW}Collecting environment variables...${NC}"
    
    # Get all env vars, sorted and cleaned
    env | sort > /tmp/env_current.txt
    
    echo -e "${GREEN}Your current environment has $(wc -l < /tmp/env_current.txt) variables${NC}"
    echo ""
    
    # Check if we have a reference file
    if [[ -f "env_reference.txt" ]]; then
        echo -e "${CYAN}Comparing with reference environment...${NC}"
        
        # Find differences (like a detective finding clues)
        comm -3 /tmp/env_current.txt env_reference.txt > /tmp/env_diff.txt
        
        diff_count=$(wc -l < /tmp/env_diff.txt)
        
        if [[ $diff_count -eq 0 ]]; then
            echo -e "${GREEN}🎉 Perfect match! Your environment is boringly normal.${NC}"
        else
            echo -e "${RED}🚨 Found $diff_count differences! Your machine is special!${NC}"
            echo -e "${YELLOW}Here are the juicy details:${NC}"
            cat /tmp/env_diff.txt
            echo ""
            echo -e "${CYAN}Tip: Save someone else's environment with './env-roulette.sh save'${NC}"
        fi
    else
        echo -e "${YELLOW}No reference file found. Be the first to save your environment!${NC}"
        echo -e "Run: ${GREEN}./env-roulette.sh save${NC} to create a reference"
    fi
}

# Save current environment as reference (for when you're feeling generous)
save_env() {
    echo -e "${CYAN}💾 Saving your environment as the 'normal' reference...${NC}"
    echo -e "${YELLOW}(Future developers will judge you for this)${NC}"
    
    env | sort > env_reference.txt
    echo -e "${GREEN}Saved $(wc -l < env_reference.txt) variables to env_reference.txt${NC}"
    echo -e "${CYAN}Now others can discover how weird YOUR setup is!${NC}"
}

# Show usage because people forget things
show_help() {
    echo -e "${CYAN}Environment Variable Roulette${NC}"
    echo "Usage:"
    echo "  ./env-roulette.sh          - Compare with reference environment"
    echo "  ./env-roulette.sh save     - Save your environment as reference"
    echo "  ./env-roulette.sh help     - Show this helpful message"
    echo ""
    echo -e "${YELLOW}Because 'works on my machine' isn't a valid excuse... it's a mystery!${NC}"
}

# Main script logic (simpler than your average bug)
case "${1}" in
    "save")
        save_env
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    "")
        compare_env
        ;;
    *)
        echo -e "${RED}Unknown option: $1${NC}"
        show_help
        exit 1
        ;;
esac

# Clean up like a responsible adult
rm -f /tmp/env_current.txt /tmp/env_diff.txt 2>/dev/null