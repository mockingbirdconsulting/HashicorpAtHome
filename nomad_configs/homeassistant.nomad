# Hashicorp At Home - A series of blog posts by Mockingbird Consulting
# Read the original at https://www.mockingbirdconsulting.co.uk/blog/2019-01-05-hashicorp-at-home/
#
# This code is licensed under the MIT License, and remains the copyright of Mockingbird Consulting Ltd.

# This configuration will launch homeassistant.io and have it hosted at homeassistant.service.consul 
# (assuming the default domain of .consul has been retained from the original articles).
#
# Configuration for HomeAssistant will be saved to the host machine in /srv/home_assistant/config,
# so if you have an existing HomeAssistant configuration you should be able to drop the files in to
# /srv/home_assistant/config and see all your existing configuration in the HomeAssistant UI.

job "homeassistant" {
  datacenters = ["homeserver"]
  type = "service"
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }
  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }
  group "homeassistant" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    ephemeral_disk {
      size = 300
    }
    task "homeassistant_core" {
      driver = "docker"
      config {
        image = "homeassistant/home-assistant"
        network_mode = "bridge"
        volumes = [
            "/srv/home_assistant/config:/config",
            "/etc/localtime:/etc/localtime:ro"
        ]
        port_map {
          homeassistant_core = 8123
        }
      }
      resources {
        cpu    = 500 # 500 MHz
        memory = 1024 # 1G
        network {
          mbits = 100
          port "homeassistant_core" {}
        }
      }
      service {
        name = "homeassistant"
        tags = ["homeassistant", "homeautomation"]
        port = "homeassistant_core"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
