# Graphics Module

GPU and graphics hardware configuration, primarily for AMD hardware.

## Purpose

Configures GPU drivers, hardware acceleration, and graphics monitoring/management tools.

## Package Organization

Packages are organized in `packages.nix` by category:
- **amd**: AMD GPU monitoring and management (radeontop, corectrl, amdgpu_top)
- **wayland**: Wayland utilities (wayland-utils)
- **vulkan**: (commented) Vulkan debugging tools
- **opengl**: (commented) OpenGL debugging tools
- **compute**: (commented) ROCm compute tools

## What Goes Here

**System-level packages:**
- GPU monitoring tools (radeontop, amdgpu_top)
- Hardware management utilities (corectrl)
- Graphics debugging tools
- Wayland/graphics utilities

**User graphics apps go to:** `home/common/apps.nix`

## Hardware Configuration

- **Mesa**: OpenGL + RADV Vulkan for AMD
- **VA-API**: Hardware video acceleration
- **Vulkan Loader**: Vulkan ICD loader
- **32-bit support**: Enabled for gaming

## Kernel Parameters

- `amdgpu.gpu_recovery=1`: Enables GPU recovery for stability

## Environment Variables

- `HIP_PLATFORM=amd`: AMD GPU compute platform
- `GSK_RENDERER=ngl`: Forces GTK4 to OpenGL (stable on Wayland)

## Programs

- `corectrl`: GPU fan curve and frequency control with polkit integration

## Debug Tools

Additional debugging tools are available commented out in `packages.nix`:
- Vulkan validation layers and tools
- Mesa demos (glxinfo, glxgears)
- ROCm compute libraries

Uncomment these only when needed to avoid potential conflicts.
