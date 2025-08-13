> [!NOTE]
>
> AI-generated article, but it's useful in this case. So, I added some tweaks to it and published it here.
>

### 💛 A Beginner's Guide to Git for Compiling Kernels

---

This guide will walk you through the essential Git commands, from understanding branches to advanced history manipulation. For a more visual and integrated experience, we recommend using a code editor like **Visual Studio Code**, which has excellent built-in Git support that can help you visualize branches, stage changes, and resolve conflicts.

---

#### Understanding Branches in Git

Before diving into commands, it's crucial to understand Git's most powerful feature: **branches**.

Imagine your project's history as a single timeline of commits. A branch is essentially a movable pointer to one of these commits. The default branch is usually named `main` or `master`.

When you want to work on a new feature or fix a bug, you create a new branch. This new branch creates a separate timeline of commits, allowing you to work in isolation without affecting the stable `main` branch. Once your work is complete and tested, you can merge this feature branch back into the `main` branch, integrating your changes.

**Why use branches?**
*   **Parallel Development**: Multiple developers can work on different features simultaneously.
*   **Isolation**: Keep unstable code separate from the stable, production-ready codebase.
*   **Experimentation**: If an idea doesn't work out, you can simply delete the branch without any impact on the main project.
*   **Organization**: It creates a clean, understandable history of how features were developed and integrated.

#### Getting Started: The Basics

*   **`git config`**: Configure your Git installation with your name and email. This information is attached to every commit you make.
    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "youremail@example.com"
    ```

*   **`git clone`**: To get a local copy of a remote repository from a platform like GitHub.
    ```bash
    git clone https://github.com/user/repository.git
    ```

#### The Fundamental Workflow: Add, Commit, Push

This is the most common sequence of commands you will use.

1.  **`git add`**: This command stages your changes, preparing them to be committed.
    ```bash
    # Stage a single file
    git add filename.txt

    # Stage all changes in the current directory
    git add .
    ```

2.  **`git commit`**: A commit is a snapshot of your staged changes. Always write a clear and descriptive commit message.
    ```bash
    git commit -m "Your descriptive commit message"
    ```

3.  **`git push`**: This command uploads your committed changes to the remote repository.
    ```bash
    git push origin main
    # Replace "main" with the name of your branch if it's different
    ```

#### Uploading a Local Kernel Source to GitHub

If you have a kernel source on your local PC that you want to upload to a new GitHub repository, follow these steps.

1.  **Create a New Repository on GitHub**: First, go to GitHub and create a new, empty repository. Do **not** initialize it with a README, license, or `.gitignore` file. You just need the repository URL.

2. **Prepare Your Local Source**: It is critical to start with a **clean source tree**. Before initializing Git, **make sure to use a clean source**, directly extracted from `Kernel.tar.gz` with the [correct permissions applied.](https://github.com/ravindu644/Android-Kernel-Tutorials#02-extract-the-kerneltargz-from-the-source-zip-unarchive-it-using-this-command-and-please-do-not-use-any-apps-to-do-this)

3.  **Initialize the Git Repository**: Navigate to the root of your kernel source directory and initialize a new Git repository. Then, add your empty GitHub repository as the remote origin.
    ```bash
    # Initialize a git repository in your source folder
    git init -b main

    # Add the URL to your GitHub repo as the remote
    git remote add origin https://github.com/user/repository-name.git
    ```

4.  **Add, Commit, and Push Your Source**: Now you will add all your source files. Kernel `.gitignore` files often ignore firmware directories. To ensure these are included, you must force the add operation.
    ```bash
    # Stage all files, including those normally ignored by .gitignore in subdirectories
    git add -A && git add . -f

    # Create your first commit
    git commit -m "Initial commit: Add base kernel source"

    # Push the source to your GitHub repository
    git push -u origin main
    ```
    The `git add . -f` command is crucial here; the `-f` (force) flag overrides the `.gitignore` rules and ensures all necessary firmware files are tracked and uploaded.

#### Managing Your Work

*   **`git stash`**: If you need to switch branches but aren't ready to commit, `git stash` temporarily shelves your changes.
    ```bash
    git stash
    ```
    To reapply your stashed changes, use:
    ```bash
    git stash pop
    ```

*   **`git revert`**: This command creates a new commit that undoes the changes from a previous commit. It's a safe way to undo public changes because it doesn't alter the project's history.
    ```bash
    # Find the hash of the commit you want to revert
    git log

    # Revert the commit
    git revert <commit-hash>
    ```

#### Collaborating with Others

*   **`git fetch`**: Downloads commits and files from a remote repository but does not merge them. This lets you see what others have done without affecting your local work.
    ```bash
    # Fetch changes from the 'origin' remote
    git fetch origin

    # You can also fetch from another person's repository
    git remote add other-repo https://github.com/other-user/repo.git
    git fetch other-repo
    ```

*   **`git cherry-pick`**: After fetching, you can use `cherry-pick` to apply a specific commit from another branch (or another person's repo) to your current branch.
    ```bash
    git cherry-pick <commit-hash-from-other-branch>
    ```

#### Advanced: Rewriting History with Interactive Rebase

`git rebase` is a powerful tool for creating a cleaner, more linear project history. While a basic `rebase` moves your branch's commits onto the tip of another branch, an **interactive rebase** (`-i`) gives you full control over your commits *before* you push them to a remote repository.

**A Word of Caution:** Never rebase commits that have already been pushed and are being used by others. Rewriting public history can create significant problems for your collaborators.

**How to Start an Interactive Rebase**

You start an interactive rebase by telling Git how far back you want to go. You can do this relative to `HEAD` (e.g., the last 3 commits) or from a specific commit hash.
```bash
# Rebase the last 3 commits
git rebase -i HEAD~3

# Rebase all commits AFTER a specific commit hash
# (This commit hash will be the new base and will not be in the list)
git rebase -i <commit-hash>
```

**The Interactive Rebase Screen**

This command opens your default text editor with a list of commits. Each line represents a commit and starts with the command `pick`.
```bash
pick a1b2c3d Add initial feature file
pick e4f5g6h Add more logic to feature
pick i7j8k9l Fix typo in feature
pick m0n1p2q Refactor feature code

# Rebase ...
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# d, drop <commit> = remove commit
# ...
```
Now, you can edit this file to manipulate your commits.

*   **Change the order of commits**: Simply change the order of the lines in the file.
*   **`drop` or `d`**: To completely remove a commit, delete the entire line or change `pick` to `drop` (or `d`). For example, to drop the "Fix typo" commit:
    ```bash
    pick a1b2c3d Add initial feature file
    pick e4f5g6h Add more logic to feature
    d i7j8k9l Fix typo in feature
    pick m0n1p2q Refactor feature code
    ```
*   **`squash` or `s`**: This combines a commit with the one before it. Git will then prompt you to write a new commit message for the combined commit. This is great for cleaning up small, incremental commits (like "fix typo," "wip") into a single, meaningful commit.
    ```bash
    # Before: Combine the typo fix and refactor into the "add more logic" commit
    pick a1b2c3d Add initial feature file
    pick e4f5g6h Add more logic to feature
    s i7j8k9l Fix typo in feature
    s m0n1p2q Refactor feature code
    ```
    After saving, a new editor window will open, allowing you to craft a new message for the three combined commits. The `fixup` (or `f`) command is similar but discards the squashed commit's message automatically.

*   **`reword` or `r`**: This allows you to change the commit message of a specific commit without altering its content. When you save, Git will open an editor for each `reword` line for you to write a new message.

Once you save and close the interactive rebase file, Git will apply the changes. Your project history will now be cleaner and easier to read.
