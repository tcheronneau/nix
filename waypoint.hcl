project = "example-nix"

app "example-nix" {
  labels = {
    "service" = "nix",
    "env" = "dev"
  }

  build {
    use "docker" {
      build_args = {
        "APP" = "nvim"
      }
    }
  }

  deploy {
    use "docker" {}
  }
}
