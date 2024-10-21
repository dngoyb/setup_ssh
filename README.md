# SSH Key Setup Script

## Overview

This script automates the process of generating SSH keys for GitHub and GitLab, configuring your SSH settings, and setting your Git global username and email. It provides a user-friendly way to get started with Git by ensuring you have the proper SSH setup for secure communication with these platforms.

## Features

- Detects the operating system.
- Prompts for GitHub and GitLab email addresses to generate SSH keys.
- Allows the user to set a global Git username and email.
- Creates or updates the SSH configuration file.
- Outputs the generated public keys for easy copying.
- Provides instructions for adding SSH keys to GitHub and GitLab.
- Tests SSH connections to both platforms.

## Requirements

- A Unix-like operating system (Linux, macOS, or Windows with a compatible shell).
- `ssh-keygen` and `ssh-agent` should be available.
- Git should be installed.

## Usage

1. **Run the Script**: Open a terminal (use Git Bash if you're on Windows) and execute the script:

   ```bash
   ./setup_ssh.sh
   ```

2. **Follow the Prompts**:

   - Enter your GitHub email for the SSH key (leave blank if you don't want to generate).
   - Enter your GitLab email for the SSH key (leave blank if you don't want to generate).
   - Enter your Git username.
   - Choose which email to set as your Git global email (1 for GitHub, 2 for GitLab, leave blank for none).

3. **SSH Key Generation**:

   - The script checks if SSH keys already exist for GitHub and GitLab.
   - If not, it generates new SSH keys using `ssh-keygen` and adds them to the SSH agent.

4. **SSH Configuration**:

   - The script creates or updates the `~/.ssh/config` file, adding entries for GitHub and GitLab.

5. **Output Public Keys**:

   - The script displays your generated public keys for both platforms, which you can copy to your clipboard to add to your accounts.

6. **Setting Global Git Configurations**:

   - The script sets your Git username and the chosen email globally using `git config`.

7. **Testing SSH Connections**:
   - The script provides commands to test your SSH connection to both GitHub and GitLab.

## Example

```bash
Detected operating system: Linux
Enter your GitHub email for the SSH key (leave blank if you don't want to generate): user@example.com
Enter your GitLab email for the SSH key (leave blank if you don't want to generate): user@example.org
Enter your Git username: yourusername
Which email do you want to set as your Git global email? (1 for GitHub, 2 for GitLab, leave blank for none): 1
```

## Notes

- If you choose to generate SSH keys, ensure you copy the public keys to your GitHub and GitLab accounts.
- For security, the script sets appropriate permissions on the SSH configuration file.

## Conclusion

This script simplifies the setup of SSH keys and Git configuration for developers using GitHub and GitLab. With just a few prompts, you can ensure your environment is ready for secure interactions with your repositories.

## Instructions for Adding SSH Keys

### For GitHub:

1. Go to GitHub.com > Settings > SSH and GPG keys > New SSH key.
2. Paste the GitHub public key and give it a title.

### For GitLab:

1. Go to GitLab.com > Preferences > SSH Keys.
2. Paste the GitLab public key and give it a title.

## Testing SSH Connections

To test your connection:

### For GitHub:

Run the following command:

```bash
ssh -T git@github.com
```

You should see a message confirming successful authentication.

### For GitLab:

Run the following command:

```bash
ssh -T git@gitlab.com
```

You should also see a message confirming successful authentication.
