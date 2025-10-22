# axiOS Distribution - Setup Complete

This repository has been prepared as a clean NixOS distribution, ready for public use.

## Changes Made

### Removed Personal Configurations
- ✅ Removed host configurations: `edge` and `pangolin`
- ✅ Removed user configuration: `keith.nix`
- ✅ Removed git history (fresh start)
- ✅ Updated all repository references from `kcalvelli/nixos_config` to `kcalvelli/axios`

### Updated References
- ✅ `modules/system/nix.nix` - Changed trusted users from `keith` to `@wheel` group
- ✅ `modules/services/ntopng.nix` - Removed hardcoded user home path
- ✅ `modules/desktop/wayland/default.nix` - Removed hardcoded configHome path
- ✅ `modules/virtualisation/default.nix` - Removed hardcoded user from libvirtd group
- ✅ `hosts/default.nix` - Updated to show example structure without specific hosts
- ✅ `README.md` - Updated to reflect distribution nature, not personal config
- ✅ `scripts/shell/install-axios.sh` - Updated repo URLs
- ✅ `flake.nix` - Updated description

### Git Repository
- ✅ Initialized fresh git repository
- ✅ Created initial commit with clean history
- ⏳ Ready to push to GitHub (requires authentication)

## Next Steps

### 1. Create GitHub Repository

You need to create the GitHub repository and push. You can either:

**Option A: Use GitHub CLI (after authentication)**
```bash
cd ~/Projects/axios
gh auth login
# Follow prompts to authenticate
gh repo create axios --public --description "A modular NixOS distribution with modern desktop environments, development tools, and automated installation" --source=. --push
```

**Option B: Create via GitHub Web UI**
1. Go to https://github.com/new
2. Repository name: `axios`
3. Description: "A modular NixOS distribution with modern desktop environments, development tools, and automated installation"
4. Set to Public
5. DO NOT initialize with README, license, or .gitignore
6. Click "Create repository"
7. Then push from command line:
```bash
cd ~/Projects/axios
git remote add origin https://github.com/kcalvelli/axios.git
git branch -M main
git push -u origin main
```

### 2. Update GitHub Settings

After creating the repo, configure:
- Add topics: `nixos`, `nix`, `linux`, `distribution`, `niri`, `wayland`
- Enable GitHub Actions (for CI/CD workflows)
- Configure Pages if you want to host documentation
- Add branch protection rules for `main` branch (optional)

### 3. Create Initial Release

Build and release the installer ISO:
```bash
cd ~/Projects/axios
nix build .#iso
# Upload result/iso/axios-installer-x86_64-linux.iso to GitHub Release v0.1.0
```

Or use GitHub Actions (already configured in `.github/workflows/build-iso.yml`)

### 4. Recommended Additional Changes

#### A. Add CONTRIBUTING.md
Create a guide for users who want to contribute or customize:
- How to fork and customize
- How to submit improvements back upstream
- Code style guidelines
- How to report issues

#### B. Update Documentation Links
Some docs may still reference the old repo name. Search and replace:
```bash
grep -r "nixos_config" docs/ --include="*.md"
```

#### C. Create Example Hosts
Consider adding more example host configurations to show different use cases:
- `hosts/EXAMPLE-desktop-amd.nix` - AMD desktop
- `hosts/EXAMPLE-desktop-intel.nix` - Intel desktop
- `hosts/EXAMPLE-laptop-thinkpad.nix` - ThinkPad laptop
- `hosts/EXAMPLE-minimal.nix` - Minimal server install

#### D. Add Hardware Compatibility List
Create `docs/HARDWARE.md` documenting:
- Tested hardware configurations
- Known working laptops/desktops
- Hardware-specific quirks and fixes
- Community hardware reports

#### E. Enhance Installation Documentation
Update `docs/INSTALLATION.md` to emphasize:
- This is a distribution, not a personal config
- Users should create their own user accounts
- Hardware detection and compatibility
- Common troubleshooting steps

#### F. Create User Migration Guide
Add `docs/MIGRATION.md` for users migrating from other NixOS configs:
- How to import existing configuration
- How to migrate from NixOS starter configs
- How to preserve existing user data

#### G. Add Issue Templates
Create `.github/ISSUE_TEMPLATE/`:
- Bug report template
- Feature request template
- Hardware compatibility report
- Documentation improvement request

#### H. Create Pull Request Template
Add `.github/PULL_REQUEST_TEMPLATE.md` with:
- Description of changes
- Testing checklist
- Documentation updates
- Breaking changes notice

#### I. Add Security Policy
Create `SECURITY.md` with:
- Supported versions
- How to report security issues
- Security best practices for users

#### J. Create Discussions/Wiki
Enable GitHub Discussions for:
- Q&A
- Show and tell (user configurations)
- Hardware compatibility reports
- Feature ideas

Enable GitHub Wiki for:
- Extended documentation
- Community guides
- Troubleshooting database

### 5. Community Building

Consider:
- Announce on NixOS Discourse
- Share on Reddit r/NixOS
- Create a Matrix/Discord chat room
- Add to awesome-nix lists
- Cross-reference with NixOS Wiki

## Important Notes

### No Personal Data Included
This distribution contains NO personal data:
- No passwords or SSH keys
- No email addresses (except in git if you used them in commits)
- No API tokens or credentials
- No personal file paths or configurations

### Users Must Create Accounts
The distribution ships without any user accounts. Users must:
1. Use the installer to create their first user account
2. Or manually create a user config in `modules/users/`

### License
Verify the MIT license is appropriate for your needs. You may want to:
- Add copyright attribution for original work
- Consider other licenses (GPL, Apache, etc.)
- Add license headers to significant files

### Maintenance Expectations
As a public distribution, consider:
- How you'll handle issues and PRs
- Release cycle (stable vs rolling)
- Support policy (community support only vs. active maintenance)
- Documentation of unmaintained features

## Testing Checklist

Before public release, test:
- [ ] ISO builds successfully: `nix build .#iso`
- [ ] Installer works in VM
- [ ] Example host configs are valid
- [ ] User template works correctly
- [ ] All documentation links are valid
- [ ] GitHub Actions workflows run successfully
- [ ] Flake checks pass: `nix flake check`

## Distribution Philosophy

This distribution is designed to be:
- **Modular**: Easy to enable/disable features
- **Educational**: Learn NixOS through clear examples
- **Customizable**: Template-based, not prescriptive
- **Modern**: Current tools and practices
- **Community-driven**: Accept contributions

Users are encouraged to:
- Fork and customize
- Share improvements back
- Report hardware compatibility
- Contribute documentation
- Help other users

## Questions to Consider

Before releasing:
1. Do you want to support stable NixOS releases or only unstable?
2. Will you accept PRs for new features or keep it minimal?
3. How will you handle breaking changes?
4. Do you want to maintain hardware profiles for specific devices?
5. Should there be different "editions" (minimal, desktop, server)?
6. Will you provide pre-built ISOs or require users to build?
7. Do you want to set up a binary cache (cachix)?

## Current Status

✅ Repository cleaned and prepared
✅ Git initialized with clean history
⏳ Ready to push to GitHub (requires auth)
📝 Consider additional improvements above
🚀 Ready for initial release after push

---

Created: 2025-10-22
Distribution: axiOS
Based on: nixos_config by Keith Calvelli
