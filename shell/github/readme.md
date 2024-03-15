# GitHub Operations Script

This script facilitates various operations related to GitHub repositories using GitHub CLI (`gh`) and Git commands. It simplifies tasks such as cloning repositories, creating pull requests, and managing branches.

## Prerequisites

- **GitHub CLI (`gh`)**: Ensure GitHub CLI is installed and configured in your environment. GitHub CLI is a command-line interface for GitHub that allows you to interact with GitHub repositories directly from your terminal.

## Usage

1. **Set Variables**: Before using the script, ensure that all necessary variables are correctly set. These variables include GitHub-related details such as the organization name, repository details, branch names, etc.

   ```bash
   export GH_HOST="github.com"
   export REPO_ORG="tridenteye"
   export BRANCH="main"
   export CLONE_ROOT_DIR=""
   export REPO_LIST_FILE="repo-flat"
   export NEW_BRANCH=""
   ```

2. **Execute Operations**: Run the script with appropriate commands to perform desired operations.

   ```bash
   ./github-run.sh [clone | pr-create]
   ```

   - `clone`: Clones repositories listed in the specified file (`repo-flat`) to the specified directory (`CLONE_ROOT_DIR`) from the GitHub organization (`tridenteye`).
   - `pr-create`: Creates pull requests for the changes made in each cloned repository.

## Script Functions

- **gh-login**: Logs in to GitHub using `gh` CLI, enabling authentication for subsequent GitHub operations.
- **git-clone**: Clones repositories from GitHub based on provided organization, repository, and branch details.
- **pr-create**: Creates a pull request for the changes made in the cloned repositories, with customizable messages and issue references.

## Environment Variables

- **GH_HOST**: Hostname for GitHub. Default value is `github.com`.
- **REPO_ORG**: GitHub organization name. Default value is `tridenteye`.
- **BRANCH**: Branch to clone. Default value is `main`.
- **CLONE_ROOT_DIR**: Directory to clone repositories.
- **REPO_LIST_FILE**: File containing a list of repositories to clone. Default value is `repo-flat`.
- **NEW_BRANCH**: Branch to checkout for making changes.

## Important Notes

- Ensure that GitHub CLI (`gh`) is properly configured and authenticated in your environment.
- Review and customize the script according to your specific GitHub organization and repository requirements.
- Verify that you have the necessary permissions to perform the operations specified in the script.

## Disclaimer

This script comes with no warranties or guarantees. Use it at your own risk. Always review and understand the actions performed by the script before execution.
