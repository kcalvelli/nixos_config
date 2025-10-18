# Services Module

Optional server services and applications.

## Purpose

Provides opt-in server services like web servers, home automation, network monitoring, and AI interfaces.

## Available Services

### Caddy (`caddy.nix`)
Modern web server and reverse proxy.
- Enable with: `services.caddy-proxy.enable = true`
- Automatic HTTPS with Let's Encrypt
- Configure virtual hosts in host config

### OpenWebUI (`openwebui.nix`)
Web interface for Large Language Models (Ollama).
- Enable with: `services.openwebui.enable = true`
- Runs on port 3000
- Integrates with Ollama for local AI

### Home Assistant (`home-assistant.nix`)
Home automation platform.
- Enable with: `services.hass.enable = true`
- Web interface on port 8123
- MQTT integration support

### MQTT (`mqtt.nix`)
Message broker for IoT devices.
- Enable with: `services.mqtt.enable = true`
- Uses Mosquitto broker
- Default port 1883

### ntopng (`ntopng.nix`)
Network traffic monitoring and analysis.
- Enable with: `services.ntop.enable = true`
- Web interface for network insights
- Real-time traffic monitoring

## What Goes Here

**Server services:**
- Web servers and proxies
- Home automation platforms
- Network monitoring tools
- Self-hosted applications
- IoT service brokers

**User applications go to:** `home/common/apps.nix`

## Usage in Host Configuration

```nix
{
  services = {
    caddy-proxy.enable = true;
    openwebui.enable = true;
    hass.enable = true;
    mqtt.enable = true;
    # ntop.enable = true;  # Optional
  };
}
```

Or use the host config shorthand:

```nix
{
  hostConfig = {
    modules.services = true;
    services = {
      caddy-proxy.enable = true;
      openwebui.enable = true;
    };
  };
}
```

## Notes

- All services are opt-in (none enabled by default)
- Services automatically configure firewall rules
- Most services provide web interfaces
- Logs available via `journalctl -u service-name`
