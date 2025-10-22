{ pkgs }:
{
  # Virtualization management tools
  virt = with pkgs; [
    virt-manager
    virt-viewer
    qemu
    quickemu
    quickgui
  ];
}
