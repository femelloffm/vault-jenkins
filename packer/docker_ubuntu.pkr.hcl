packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:20.04"
  commit = true
  changes = [
    "ENV VAULT_ADDR=\"http://127.0.0.1:8200\"",
    "ENTRYPOINT [\"vault\", \"server\", \"-config=/etc/vault.d/vault.hcl\"]",
    "EXPOSE 8200"
  ]
}

build {
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    inline = [
      "apt-get update",
      "apt-get install -y python3"
    ]
  }

  provisioner "ansible" {
    playbook_file = "./ansible/playbook.yml"
    user          = "root"
  }

  post-processor "docker-tag" {
    repository = "femelloffm/vault"
    tags       = ["ubuntu", "ubuntu20.04"]
  }
}
