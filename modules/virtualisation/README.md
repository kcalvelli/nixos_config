# Virtualisation Module

Virtualization and containerization infrastructure.

## Purpose

Provides system-level configuration for containers (Podman) and virtual machines (libvirt/quickemu).

## Module Options

This module uses option-based configuration:

```nix
virt.containers.enable = true;  # Enable Podman containers
virt.libvirt.enable = true;     # Enable libvirt/quickemu VMs
```

## What Goes Here

**System-level packages:**
- Container runtimes and orchestration
- Virtual machine management tools
- USB redirection support

**No user-level packages needed** - these are system services

## Containers

When enabled:
- **Podman**: Docker-compatible container runtime
- **Docker compatibility**: `dockerCompat = true`
- **DNS**: Enabled for container networking

## Virtualization

When enabled:
- **quickemu**: Simple VM creation and management
- **quickgui**: GUI for quickemu
- **SPICE**: USB redirection for VMs
- **SPICE vdagent**: Guest agent for clipboard/display

## Configuration Example

In host configuration:
```nix
virt = {
  containers.enable = true;
  libvirt.enable = true;
};
```

## Notes

- Waydroid configuration is available but commented out
- OCI container backend defaults to Podman
- No GUI virtualization tools (virt-manager) - using quickemu for simplicity
