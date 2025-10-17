# Host Configuration Approaches

## Option 1: Simple Inline Configuration

**Best for**: Simple setups, VM templates, testing hosts

```
hosts/
├── default.nix
├── simple-laptop.nix    ← Everything in one file!
```

**simple-laptop.nix contains:**
- Hardware specification
- Module configuration  
- Services & virtualization
- Disk configuration (inline in extraConfig)
- Home-manager profile

**Pros:**
- ✅ Single file - nothing else needed
- ✅ Quick to set up
- ✅ Easy to template/copy
- ✅ Self-contained

**Cons:**
- ⚠️ Disk config mixed with host config
- ⚠️ Can be verbose for complex disk layouts

---

## Option 2: Organized with Separate Files

**Best for**: Production hosts, complex disk setups, shared configs

```
hosts/
├── default.nix
├── edge.nix             ← Main configuration
└── edge/                ← Host-specific data
    ├── disks.nix        ← Disk configuration
    └── disko/           ← (Optional) Reinstall templates
        └── default.nix
```

**edge.nix contains:**
- Hardware specification
- Module configuration
- Services & virtualization  
- Reference to disk file

**edge/disks.nix contains:**
- fileSystems declarations
- Partition UUIDs
- Mount options
- Swap configuration

**Pros:**
- ✅ Clean separation of concerns
- ✅ Easier to share/reuse disk configs
- ✅ Better for complex setups
- ✅ Cleaner git diffs

**Cons:**
- ⚠️ Requires directory creation
- ⚠️ Two files to manage

---

## When to Use Each

### Use Simple Inline When:
- Adding a VM or test host
- Disk config is straightforward (root + boot)
- You want everything in one place
- Quick prototyping

### Use Organized When:
- Production physical hardware
- Complex disk layouts (LUKS, RAID, btrfs subvolumes)
- Multiple similar hosts (share disk templates)
- You have disko configs for reinstalls
- Your existing hosts already use this pattern

---

## Migration

**Already have organized structure?** Keep it!
- Your edge and pangolin configs already use this pattern
- No need to change what works

**Adding new hosts?** Choose what fits:
- Simple VM → Use inline
- New workstation → Use organized (match existing pattern)
- Test host → Use inline

**Want to consolidate?** You can:
- Keep organized for edge/pangolin (they're already set up)
- Use inline for new simple hosts
- Mix and match as needed

Both approaches work with the same `hosts/default.nix` registry!
