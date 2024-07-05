#!/bin/bash

#####################################################################
# Script to clone a list of GitHub repositories into a target directory
#
# Usage:
#   1. Modify the 'repos' array with the desired GitHub repositories
#   2. Run the script: ./setup.sh
#   3. Enter the target directory path when prompted
#
# The script will create the target directory if it doesn't exist,
# and clone each repository from the list into the target directory.
#
# Note: This script assumes you have Git installed and configured.
#####################################################################

# Regular Colors
GREEN="\033[1;32m"           # Green
YELLOW="\033[1;33m"          # Yellow
BLUE="\033[1;34m"            # Blue
RED="\033[1;31m"             # Red
NC="\033[0m"                 # No Color

# List of GitHub repositories
REPOSITORIES=(
    "git@github.com:Magiscribe/Magiscribe-API.git"
    "git@github.com:Magiscribe/Magiscribe-Client.git"

    # Infrastructure repository is optional, comment if unneeded
    "git@github.com:Magiscribe/Magiscribe-Infrastructure.git"
)

##################################################################### PRE-REQUISITES #####################################################################

echo -e "${BLUE}Checking prerequisites...${NC}"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}AWS CLI is not installed. Please install it before proceeding.${NC}"
    exit 1
fi

# Check if Node.js is and Corepack are installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}Node.js is not installed. Please install it before proceeding.${NC}"
    exit 1
fi

if ! command -v corepack &> /dev/null; then
    echo -e "${YELLOW}Corepack is not installed. Installing it now...${NC}"
    npm install -g corepack
    echo -e "${GREEN}Corepack installed successfully${NC}"
fi

# Enable PNPM
if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}PNPM is not installed. Installing it now...${NC}"
    corepack enable pnpm
    corepack use pnpm@latest
    echo -e "${GREEN}PNPM installed successfully${NC}"
fi

echo -e "${GREEN}All prerequisites are met${NC}"

##################################################################### CLONE REPOSITORIES #####################################################################

# Prompt the user for the target directory
echo -e "${YELLOW}Enter the target directory path (default: ./Magiscribe):${NC}"
read target_dir

# Use the default target directory if none is provided
target_dir=${target_dir:-"./Magiscribe"}

# Create the target directory if it doesn't exist
mkdir -p "$target_dir"
cd "$target_dir"

# Clone each repository into the target directory
for repo in "${REPOSITORIES[@]}"; do
    echo -e "${BLUE}Cloning $repo...${NC}"
    if git clone $repo; then
        echo -e "${GREEN}Successfully cloned $repo${NC}"

        echo -e "${BLUE}Setting up $repo...${NC}"
        directory=$(echo $repo | cut -d'/' -f2 | cut -d'.' -f1)
        cd $directory
        npm run setup
        cd ..
        echo -e "${GREEN}Successfully set up $repo${NC}"
    else
        echo -e "${RED}Failed to clone $repo${NC}"
        echo -e "${RED}Exiting...${NC}"
        exit 1
    fi
done

echo -e "${GREEN}All repositories cloned successfully!${NC}"

##################################################################### AWS CONFIG #####################################################################

# Create a ~/.aws/config file, if it doesn't exist
if [ ! -f ~/.aws/config ]; then
    mkdir -p ~/.aws
    touch ~/.aws/config
fi

# Check if the config file already contains the desired content
if ! grep -q "sso_start_url = https://magiscribe.awsapps.com/start/#" ~/.aws/config; then
    echo -e "${YELLOW}Do you want to add AWS credentials to the ~/.aws/config file? (y/n)${NC}"
    read add_aws

    if [ "$add_aws" == "y" ]; then
        # Prompt for AWS account IDs
        echo -e "${YELLOW}Enter the AWS Production Account ID:${NC}"
        read prod_account_id
        
        if [ -z "$prod_account_id" ]; then
            echo -e "${RED}Production Account ID is required. Exiting AWS configuration.${NC}"
            add_aws="n"
        else
            echo -e "${YELLOW}Enter the AWS Development Account ID:${NC}"
            read dev_account_id
            
            if [ -z "$dev_account_id" ]; then
                echo -e "${RED}Development Account ID is required. Exiting AWS configuration.${NC}"
                add_aws="n"
            else
                # Prompt for SSO role name with default
                echo -e "${YELLOW}Enter the AWS SSO Role Name (default: PowerUserAccess):${NC}"
                read sso_role
                # Set default if empty
                sso_role=${sso_role:-"PowerUserAccess"}
                
                # Prompt for AWS region with default
                echo -e "${YELLOW}Enter the AWS Region (default: us-east-1):${NC}"
                read aws_region
                # Set default if empty
                aws_region=${aws_region:-"us-east-1"}
                
                echo -e "${GREEN}Adding AWS credentials to the ~/.aws/config file...${NC}"
                cat <<EOF >> ~/.aws/config
[sso-session magiscribe]
sso_start_url = https://magiscribe.awsapps.com/start/#
sso_region = $aws_region
sso_registration_scopes = sso:account:access

[profile magiscribe-prod]
sso_session = magiscribe
sso_account_id = $prod_account_id
sso_role_name = $sso_role
region = $aws_region
output = json

[profile magiscribe-dev]
sso_session = magiscribe
sso_account_id = $dev_account_id
sso_role_name = $sso_role
region = $aws_region
output = json
EOF
                echo -e "${GREEN}AWS credentials added to the ~/.aws/config file${NC}"
            fi
        fi
    fi
else
    echo -e "${GREEN}AWS credentials already partially configured in the ~/.aws/config file${NC}"
    echo -e "${YELLOW}Please ensure the correct AWS credentials are configured${NC}"
fi

##################################################################### VS CODE WORKSPACE #####################################################################

# Creates a new VS Code workspace file
echo -e "${BLUE}Creating VS Code workspace file...${NC}"
echo "{
    \"folders\": [ " > Magiscribe.code-workspace

for repo in "${REPOSITORIES[@]}"; do
    repo_name=$(echo $repo | cut -d'/' -f2 | cut -d'.' -f1)
    echo "        {
            \"path\": \"./$repo_name\"
        }," >> Magiscribe.code-workspace
done
echo "    ]
}" >> Magiscribe.code-workspace
echo -e "${GREEN}VS Code workspace file created${NC}"

# Open the target directory in VS Code
echo -e "${YELLOW}Do you want to open the target directory in VS Code? (y/n)${NC}"
read open_vscode

if [ "$open_vscode" == "y" ]; then
    code -n "Magiscribe.code-workspace"
fi
