# this is the `terraform' block, which includes:
#  - required_providers: `source' attr defines an optional hostname, namespace, and provider type.
#  - providers are installed from terraform registry by default.
#  - in example, the provider's (docker) `source` is shorthand for registry.terraform.io/kreuzweker/docker.
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      #version = "~> 3.0.1"
    }
  }
}

# this is `provider' block, which configures the specifies provider.
# can use multiple provider blocks to manage resources from multiple providers.
# can use different providers together, eg pass a docker image id to a k8s service.
provider "docker" {}

# this is `resource' block, which define components of infra.
# - `resource' blocks have two strings before the block ('docker_image' [resource type], and 'nginx' [resource name]).
# - the prefix of the '[resource] type' maps to the name of the provider ('docker')
# - together, the resource_type and the resource name form a unique ID for the resource.
# - eg, the ID for the docker image herein is `docker_image.nginx`
## but again, how the fuck would one know that the 'image_id' attr is available to be accessed?**
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}
