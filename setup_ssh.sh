#!/bin/bash

# Prompt for emails for SSH keys
read -p "Enter your GitHub email for the SSH key: " github_email
read -p "Enter your GitLab email for the SSH key: " gitlab_email

# Generate SSH keys for GitHub
echo "Generating SSH key for GitHub..."
ssh-keygen -t rsa -b 4096 -C "$github_email" -f ~/.ssh/id_rsa_github -N ""

# Generate SSH keys for GitLab
echo "Generating SSH key for GitLab..."
ssh-keygen -t rsa -b 4096 -C "$gitlab_email" -f ~/.ssh/id_rsa_gitlab -N ""

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add the SSH keys to the SSH agent
ssh-add ~/.ssh/id_rsa_github
ssh-add ~/.ssh/id_rsa_gitlab

# Create or update the SSH config file
config_file=~/.ssh/config

if [ ! -f "$config_file" ]; then
    touch "$config_file"
    echo "Creating SSH config file at $config_file"
fi

# Add GitHub and GitLab configuration to the SSH config file
{
    echo ""
    echo "# GitHub configuration"
    echo "Host github.com"
    echo "    HostName github.com"
    echo "    User git"
    echo "    IdentityFile ~/.ssh/id_rsa_github"
    echo ""
    echo "# GitLab configuration"
    echo "Host gitlab.com"
    echo "    HostName gitlab.com"
    echo "    User git"
    echo "    IdentityFile ~/.ssh/id_rsa_gitlab"
} >> "$config_file"

# Set permissions for the SSH config file
chmod 600 "$config_file"

# Display the public keys
echo "Your GitHub public key (copy this to GitHub):"
cat ~/.ssh/id_rsa_github.pub
echo ""
echo "Your GitLab public key (copy this to GitLab):"
cat ~/.ssh/id_rsa_gitlab.pub
echo ""

# Instructions for adding keys to GitHub and GitLab
echo "Instructions to add your SSH keys:"
echo "1. For GitHub:"
echo "   - Go to GitHub.com > Settings > SSH and GPG keys > New SSH key"
echo "   - Paste the GitHub public key and give it a title."
echo ""
echo "2. For GitLab:"
echo "   - Go to GitLab.com > Preferences > SSH Keys"
echo "   - Paste the GitLab public key and give it a title."
echo ""


# Instructions for testing SSH connections
echo "Testing your SSH connection:"
echo "1. To test your connection to GitHub, run the following command:"
echo "   ssh -T git@github.com"
echo "   You should see a message confirming successful authentication."
echo ""
echo "2. To test your connection to GitLab, run the following command:"
echo "   ssh -T git@gitlab.com"
echo "   You should also see a message confirming successful authentication."
echo ""


