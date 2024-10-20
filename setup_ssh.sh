#!/bin/bash

# Function to identify the OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "MacOS"
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        echo "Cygwin"
    elif [[ "$OSTYPE" == "msys" ]]; then
        echo "Mingw"
    else
        echo "Unknown OS"
        exit 1
    fi
}

# Detect the operating system
os_type=$(detect_os)
echo "Detected operating system: $os_type"

echo "________________________________________________________________________________"

# Prompt for emails for SSH keys
read -p "Enter your GitHub email for the SSH key (leave blank if you don't want to generate): " github_email
read -p "Enter your GitLab email for the SSH key (leave blank if you don't want to generate): " gitlab_email

# Prompt for Git username
read -p "Enter your Git username: " git_username

# Prompt for preferred Git email (GitHub or GitLab)
read -p "Which email do you want to set as your Git global email? (1 for GitHub, 2 for GitLab, leave blank for none): " email_choice

echo "________________________________________________________________________________"

# Function to generate SSH keys
generate_ssh_key() {
    local email=$1
    local file=$2
    echo "Generating SSH key for $file..."
    ssh-keygen -t rsa -b 4096 -C "$email" -f "$file" -N "" || {
        echo "Failed to generate SSH key for $file."
        exit 1
    }
}

# Check if keys should be generated
if [[ -n "$github_email" ]]; then
    if [ -f ~/.ssh/id_rsa_github ]; then
        echo "SSH key for GitHub already exists at ~/.ssh/id_rsa_github. Skipping generation."
    else
        generate_ssh_key "$github_email" ~/.ssh/id_rsa_github
    fi
else
    echo "No GitHub email provided. Skipping SSH key generation for GitHub."
fi

if [[ -n "$gitlab_email" ]]; then
    if [ -f ~/.ssh/id_rsa_gitlab ]; then
        echo "SSH key for GitLab already exists at ~/.ssh/id_rsa_gitlab. Skipping generation."
    else
        generate_ssh_key "$gitlab_email" ~/.ssh/id_rsa_gitlab
    fi
else
    echo "No GitLab email provided. Skipping SSH key generation for GitLab."
fi

echo "________________________________________________________________________________"

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add the SSH keys to the SSH agent if they were generated
[[ -f ~/.ssh/id_rsa_github ]] && ssh-add ~/.ssh/id_rsa_github
[[ -f ~/.ssh/id_rsa_gitlab ]] && ssh-add ~/.ssh/id_rsa_gitlab

echo "________________________________________________________________________________"

# Create or update the SSH config file
config_file=~/.ssh/config

if [ ! -f "$config_file" ]; then
    touch "$config_file"
    echo "Creating SSH config file at $config_file"
fi

# Add GitHub and GitLab configuration to the SSH config file
{
    echo ""
    if [[ -n "$github_email" ]]; then
        echo "# GitHub configuration"
        echo "Host github.com"
        echo "    HostName github.com"
        echo "    User git"
        echo "    IdentityFile ~/.ssh/id_rsa_github"
        echo ""
    fi
    
    if [[ -n "$gitlab_email" ]]; then
        echo "# GitLab configuration"
        echo "Host gitlab.com"
        echo "    HostName gitlab.com"
        echo "    User git"
        echo "    IdentityFile ~/.ssh/id_rsa_gitlab"
        echo ""
    fi
} >> "$config_file"

# Set permissions for the SSH config file
chmod 600 "$config_file"

echo "________________________________________________________________________________"

# Display the public keys if they were generated
if [[ -f ~/.ssh/id_rsa_github ]]; then
    echo "Your GitHub public key (copy this to GitHub):"
    cat ~/.ssh/id_rsa_github.pub
    echo ""
fi

if [[ -f ~/.ssh/id_rsa_gitlab ]]; then
    echo "Your GitLab public key (copy this to GitLab):"
    cat ~/.ssh/id_rsa_gitlab.pub
    echo ""
fi

# Instructions for adding keys to GitHub and GitLab
echo "Instructions to add your SSH keys:"
if [[ -n "$github_email" ]]; then
    echo "1. For GitHub:"
    echo "   - Go to GitHub.com > Settings > SSH and GPG keys > New SSH key"
    echo "   - Paste the GitHub public key and give it a title."
    echo ""
fi

if [[ -n "$gitlab_email" ]]; then
    echo "2. For GitLab:"
    echo "   - Go to GitLab.com > Preferences > SSH Keys"
    echo "   - Paste the GitLab public key and give it a title."
    echo ""
fi

echo "________________________________________________________________________________"

# Set Git global username and email
git config --global user.name "$git_username"

# Set the preferred Git global email based on user choice
if [[ "$email_choice" -eq 1 ]]; then
    [[ -n "$github_email" ]] && git config --global user.email "$github_email" && echo "Git global email set to your GitHub email: $github_email"
elif [[ "$email_choice" -eq 2 ]]; then
    [[ -n "$gitlab_email" ]] && git config --global user.email "$gitlab_email" && echo "Git global email set to your GitLab email: $gitlab_email"
else
    echo "No valid choice made for Git global email configuration."
fi

echo "________________________________________________________________________________"

# Instructions for testing SSH connections
echo "Testing your SSH connection:"
if [[ -n "$github_email" ]]; then
    echo "1. To test your connection to GitHub, run the following command:"
    echo "   ssh -T git@github.com"
    echo "   You should see a message confirming successful authentication."
    echo ""
fi

if [[ -n "$gitlab_email" ]]; then
    echo "2. To test your connection to GitLab, run the following command:"
    echo "   ssh -T git@gitlab.com"
    echo "   You should also see a message confirming successful authentication."
    echo ""
fi
