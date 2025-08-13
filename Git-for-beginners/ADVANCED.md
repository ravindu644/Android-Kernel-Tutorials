> [!NOTE]
>
> AI-generated article, but it's useful in this case. So, I added some tweaks to it and published it here.
>

# Complete Git Guide for Android Kernel Development

## What is Git?

Git is a **version control system** - think of it as a sophisticated "save game" system for your kernel source code. Just like you save your progress in a video game at different checkpoints, Git lets you save snapshots of your kernel at different stages. If a kernel patch breaks something, you can always go back to a previous working state.

### Why Do We Need Git for Kernel Development?

Android kernel development involves:
- Applying patches from different sources (OEM, community, upstream)
- Experimenting with new features without breaking your working kernel
- Tracking exactly what changes cause specific behaviors
- Collaborating with other developers
- Maintaining multiple kernel versions for different devices
- Cherry-picking specific commits from other kernel trees

Git solves all these problems and more.

## Core Concepts You Must Understand

### 1. Repository (Repo)
A repository is your kernel source folder that Git is watching. It contains:
- Your kernel source files (`arch/`, `drivers/`, `kernel/`, etc.)
- A hidden `.git` folder that stores all the version history
- Configuration files like `.gitignore`

### 2. Commits
A commit is like taking a snapshot of your entire kernel source at a specific moment. Each commit has:
- A unique ID (called a hash) like `a1b2c3d4...`
- A message describing what changed (e.g., "arm64: dts: Add support for new display panel")
- A timestamp and author information
- The exact state of all kernel files at that moment

### 3. Branches
Think of branches like parallel versions of your kernel:
- The main branch (usually `main` or based on Android version like `android-4.19`) is your stable kernel
- Feature branches are where you experiment with new patches or drivers
- Device-specific branches for different phone models
- You can switch between branches instantly

### 4. Remote Repository
This is a copy of your kernel repository stored on GitHub/GitLab. Common remotes in kernel development:
- `origin`: Your personal kernel repository
- `upstream`: The original OEM kernel source
- `caf`: CodeAurora Forum (Qualcomm) kernel sources
- `aosp`: Android Open Source Project kernel

## Essential Git Commands

### Initial Setup (Do This Once)

```bash
# Tell Git who you are (required for every commit)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set your default text editor for commit messages
git config --global core.editor "nano"  # or "vim", "code", etc.

# Useful for kernel work - show more context in diffs
git config --global diff.context 5
```

### Starting with Android Kernel Source

**Method 1: Clone an existing kernel**
```bash
# Clone your device's kernel source
git clone https://github.com/vendor/device_kernel_source.git
cd device_kernel_source

# Add upstream sources as remotes
git remote add caf https://source.codeaurora.org/quic/la/kernel/msm
git remote add upstream https://github.com/original_oem/kernel_source.git
```

**Method 2: Initialize a new kernel repository**
```bash
# Extract your kernel source from manufacturer's package
tar -xzf kernel_source.tar.gz
cd kernel_source

# Initialize Git (CRITICAL: Start with clean source!)
git init -b main

# Add your GitHub repository as remote
git remote add origin https://github.com/yourusername/your_kernel.git
```

### The Kernel Developer's Daily Workflow

#### 1. Check Your Current Status
```bash
# See what files you've modified
git status

# This shows:
# - Modified kernel files (.c, .h, Makefile, etc.)
# - Which files are staged for commit
# - Current branch (e.g., android-4.19-stable)
```

#### 2. Stage Your Kernel Changes
```bash
# Stage specific files
git add drivers/gpu/drm/msm/dsi/dsi_panel.c
git add arch/arm64/boot/dts/qcom/your-device.dtsi

# Stage all modified files
git add .

# Stage everything including firmware (important for kernels!)
git add -A && git add . -f
```

**The `-f` flag is crucial for kernels** because `.gitignore` files often exclude firmware directories that you actually need to track.

#### 3. Commit Your Changes
```bash
# Commit with proper kernel-style message
git commit -m "arm64: dts: Add support for new touch panel

- Add touch panel device tree entries
- Configure GPIO settings for panel
- Update panel power sequences"
```

**Good kernel commit messages:**
- ✅ "drivers: input: Fix null pointer dereference in touchscreen driver"
- ✅ "arm64: defconfig: Enable new camera sensor driver"
- ✅ "mm: Fix memory leak in page allocation"
- ❌ "fix" (too vague)
- ❌ "update driver" (which driver? what update?)

#### 4. Push to Your Repository
```bash
# Push to your GitHub repository
git push origin main

# If it's your first push
git push -u origin main
```

### Working with Kernel Branches

Branches are essential for kernel development:

```bash
# Create branch for device-specific changes
git checkout -b device-specific-patches

# Create branch for testing new feature
git checkout -b test-new-scheduler

# Create branch for different Android version
git checkout -b android-12-port

# List all branches
git branch -a

# Switch between branches
git checkout main
git checkout device-specific-patches

# Delete a branch after merging
git branch -d test-feature
```

**Common Kernel Branch Naming:**
- `android-[version]`: Android version bases
- `device-[codename]`: Device-specific modifications  
- `feature-[name]`: New features or drivers
- `fix-[issue]`: Bug fixes
- `upstream-[version]`: Tracking upstream versions

### Getting Updates from Multiple Sources

Kernel development involves pulling changes from various sources:

```bash
# Fetch all remotes without merging
git fetch --all

# See what's available from CAF
git fetch caf
git log --oneline caf/main..HEAD  # What you have that CAF doesn't
git log --oneline HEAD..caf/main  # What CAF has that you don't

# Pull updates from upstream
git pull upstream android-4.19

# Pull latest from your own repository  
git pull origin main
```

### Cherry-picking: The Kernel Developer's Best Friend

Cherry-picking allows you to take specific commits from other kernel trees:

```bash
# Fetch from the source repository first
git fetch upstream

# Cherry-pick a specific commit
git cherry-pick a1b2c3d4e5f6

# Cherry-pick multiple commits
git cherry-pick commit1 commit2 commit3

# Cherry-pick a range of commits
git cherry-pick commit1..commit5

# Cherry-pick with conflict resolution
git cherry-pick a1b2c3d4
# If conflicts occur:
# 1. Fix conflicts in the files
# 2. git add conflicted_files
# 3. git cherry-pick --continue
```

**Common Cherry-pick Scenarios:**
```bash
# Get security patches from CAF
git fetch caf
git cherry-pick caf/security-patch-commit

# Apply community improvements  
git fetch community-repo
git cherry-pick community-repo/performance-improvement

# Get specific driver fixes
git cherry-pick upstream/fix-camera-driver
```

### Using Git Stash for Kernel Work

Stash is perfect when you need to switch branches but have uncommitted kernel changes:

```bash
# Stash current changes
git stash

# Stash with a descriptive message
git stash push -m "WIP: debugging display driver issue"

# List all stashes
git stash list

# Apply most recent stash
git stash pop

# Apply specific stash
git stash apply stash@{1}

# Clear all stashes
git stash clear
```

**Kernel Stash Use Cases:**
```bash
# You're debugging a driver but need to switch branches for urgent fix
git stash push -m "debugging touchscreen driver"
git checkout hotfix-branch
# ... do hotfix ...
git checkout original-branch  
git stash pop

# Temporarily save experimental changes
git stash push -m "experimental scheduler changes"
```

### Merging Branches

When your kernel feature is ready:

```bash
# Switch to target branch
git checkout main

# Make sure you have latest changes
git pull origin main

# Merge your feature branch
git merge feature-new-driver

# For a cleaner history, use --no-ff
git merge --no-ff feature-new-driver

# Push merged changes
git push origin main

# Clean up feature branch
git branch -d feature-new-driver
git push origin --delete feature-new-driver
```

### Interactive Rebase: Clean Up Your Kernel History

**⚠️ NEVER rebase commits that have been pushed to shared repositories!**

Interactive rebase helps create clean, professional commit history:

```bash
# Rebase last 5 commits
git rebase -i HEAD~5

# Rebase all commits after a specific point
git rebase -i commit-hash
```

This opens an editor showing:
```bash
pick a1b2c3d drivers: input: Add new touchscreen driver
pick e4f5g6h drivers: input: Fix initialization bug  
pick i7j8k9l drivers: input: Add device tree bindings
pick m0n1p2q drivers: input: Update documentation
pick q3r4s5t arm64: defconfig: Enable new touchscreen driver

# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message  
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# d, drop = remove commit
```

**Common Rebase Operations for Kernels:**

```bash
# Squash small fixes into main commits
pick a1b2c3d drivers: input: Add new touchscreen driver
s e4f5g6h drivers: input: Fix initialization bug  
s i7j8k9l drivers: input: Fix compilation warning
pick m0n1p2q arm64: defconfig: Enable new touchscreen driver

# Reorder commits logically (driver first, then config)
pick a1b2c3d drivers: input: Add new touchscreen driver  
pick i7j8k9l drivers: input: Add device tree bindings
pick q3r4s5t arm64: defconfig: Enable new touchscreen driver
pick m0n1p2q drivers: input: Update documentation

# Drop commits that are no longer needed
pick a1b2c3d drivers: input: Add new touchscreen driver
d e4f5g6h drivers: input: Debug prints (drop this)
pick i7j8k9l drivers: input: Add device tree bindings
```

### Handling Merge Conflicts in Kernel Code

Conflicts happen when the same kernel code is modified in different branches:

```bash
# During merge/cherry-pick, if conflicts occur:
git status  # Shows conflicted files

# Edit conflicted files - look for conflict markers:
<<<<<<< HEAD
/* Your version of the code */
struct device_node *node = of_find_node_by_name(NULL, "touchscreen");
=======
/* Their version of the code */  
struct device_node *node = of_find_compatible_node(NULL, NULL, "vendor,touchscreen");
>>>>>>> commit-being-merged

# After resolving conflicts:
git add drivers/input/touchscreen/driver.c
git commit  # or git cherry-pick --continue
```

### Viewing Kernel History and Changes

```bash
# View commit history  
git log --oneline
git log --graph --oneline --all  # Visual branch history

# See what changed in a commit
git show commit-hash
git show HEAD~3  # Show 3 commits ago

# See changes in specific files
git log -p drivers/gpu/drm/msm/dsi/
git log --follow arch/arm64/boot/dts/qcom/device.dtsi

# Find when a bug was introduced
git bisect start
git bisect bad HEAD       # Current version has bug
git bisect good v1.0      # v1.0 was good
# Git will checkout commits for testing
git bisect bad/good       # Mark each test
git bisect reset          # When done
```

### Reverting Kernel Changes Safely

```bash
# Create a new commit that undoes a previous commit
git revert commit-hash

# Revert a merge commit (specify parent)
git revert -m 1 merge-commit-hash

# Revert multiple commits
git revert commit1 commit2 commit3

# Interactive revert
git revert --no-commit commit1 commit2
# Make manual adjustments
git commit
```

### Setting Up Your Kernel Repository

**First Upload to GitHub:**

1. Extract clean kernel source with proper permissions
2. Initialize repository:
```bash
cd kernel_source
git init -b main
git remote add origin https://github.com/username/device_kernel.git

# Add all files (including firmware)
git add -A && git add . -f
git commit -m "Initial commit: Add base kernel source

Based on [OEM] kernel version [X.X.X]
Device: [Device Name]  
Android version: [X.X]
Kernel version: [X.X.X]"

git push -u origin main
```

### Kernel-Specific .gitignore

Create `.gitignore` for kernel development:
```bash
# Build outputs
*.o
*.ko
*.cmd
*.tmp
*.mod.c
.tmp_versions/
Module.symvers
modules.order

# Compiled kernel
vmlinux
System.map
.config.old
arch/*/boot/compressed/vmlinux
arch/*/boot/Image
arch/*/boot/zImage  

# IDE files
.vscode/
.idea/
*.swp
*.swo

# BUT keep firmware and device tree files!
# (Don't ignore these common kernel directories)
```

### Advanced Kernel Git Workflows

**Maintaining Multiple Device Versions:**
```bash
# Create device-specific branches
git checkout -b device-oneplus6
git checkout -b device-pixel3  
git checkout -b device-galaxys10

# Common base branch for shared changes
git checkout -b common-base
# Apply common patches here, then merge into device branches
```

**Working with Vendor Tags:**
```bash
# Create tags for releases
git tag -a v1.0-stable -m "Stable release for device"
git push origin v1.0-stable

# List tags
git tag -l

# Checkout specific tag
git checkout v1.0-stable
```

**Managing Multiple Remotes:**
```bash
# Add various kernel sources
git remote add caf https://source.codeaurora.org/quic/la/kernel/msm  
git remote add lineage https://github.com/LineageOS/android_kernel_...
git remote add upstream https://github.com/original_manufacturer/kernel

# Fetch from all remotes
git fetch --all

# See all remotes
git remote -v
```

## Kernel Development Best Practices

### 1. Commit Structure
- One logical change per commit
- Driver changes separate from configuration changes  
- Documentation updates in separate commits
- Follow Linux kernel commit message format

### 2. Branch Strategy
```bash
# Keep main branch stable and working
# Use feature branches for all changes
git checkout -b feature-new-camera-driver
# ... make changes ...
git checkout main
git merge --no-ff feature-new-camera-driver
```

### 3. Testing Before Commits
- Always compile-test your changes
- Test boot and basic functionality
- Run any available test suites
- Document testing in commit messages

### 4. Cherry-pick Carefully
- Always test cherry-picked commits
- Check for dependencies between commits
- Resolve conflicts properly
- Update commit messages if needed

## Handling Common Kernel Git Scenarios

### Scenario 1: Applying Security Patches
```bash
# Get latest security patches from CAF
git fetch caf  
git log --oneline --grep="CVE" caf/main
git cherry-pick security-patch-hash
```

### Scenario 2: Porting to New Android Version  
```bash
# Create new branch for Android version
git checkout -b android-12-port

# Cherry-pick compatible changes
git cherry-pick feature1 feature2 feature3

# Handle incompatible changes manually
```

### Scenario 3: Debugging with Git
```bash
# Find when problem was introduced
git bisect start
git bisect bad HEAD
git bisect good last-known-good-commit

# Test each suggested commit
# Compile and boot kernel
git bisect good/bad  # Based on test results
```

## Quick Command Reference for Kernel Developers

```bash
# Daily workflow
git status                              # Check current state
git add -A && git add . -f             # Stage all changes (including firmware)
git commit -m "descriptive message"    # Commit changes
git push origin branch-name            # Upload to repository

# Branch management
git checkout -b new-feature            # Create and switch to branch
git checkout main                      # Switch to main branch  
git merge --no-ff feature-branch       # Merge with merge commit
git branch -d old-branch               # Delete branch

# Getting updates
git fetch --all                        # Fetch from all remotes
git pull origin main                   # Pull latest changes
git cherry-pick commit-hash            # Apply specific commit

# History and inspection  
git log --oneline --graph              # Visual commit history
git show commit-hash                   # Show commit details
git diff HEAD~1                        # Compare with previous commit

# Stash management
git stash push -m "description"        # Save work temporarily
git stash list                         # List stashes  
git stash pop                          # Restore latest stash

# Advanced history editing (use carefully!)
git rebase -i HEAD~5                   # Interactive rebase last 5 commits
git revert commit-hash                 # Safely undo a commit
```

## Troubleshooting Common Issues

### "Your branch is ahead of origin by X commits"
```bash
git push origin current-branch
```

### "Your branch and origin have diverged"
```bash
git pull origin current-branch
# Resolve any conflicts, then:
git push origin current-branch
```

### "Cherry-pick failed due to conflicts"
```bash
# Fix conflicts in files
git add conflicted-files
git cherry-pick --continue
```

### "Accidentally committed to wrong branch"
```bash
# Move commits to correct branch
git checkout correct-branch
git cherry-pick wrong-branch-commit-hash
git checkout wrong-branch
git reset --hard HEAD~1  # Remove commit from wrong branch
```

Remember: Kernel development with Git requires patience and practice. Start with simple changes, always test your modifications, and don't hesitate to ask the community for help. Git's powerful history and branching features make it perfect for managing complex kernel codebases across multiple devices and Android versions.
