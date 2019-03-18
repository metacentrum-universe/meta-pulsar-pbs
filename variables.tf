variable "one" {
  type = "map"
  default = {
    "image" = "METACLOUD-Debian-9-x86_64-Winterfell@metacloud-dukan"
    "image_uname" = "oneadmin"
    "image_size" = "20480"
    "swap_image" = "Linux swap"
    "swap_image_uname" = "cerit-sc-admin"
    "public_network" = "metacloud-brno-public-xkimle"
    "public_network_uname" = "xkimle"
    "security_group" = "101"
    "cpu" = "4"
    "vcpu" = "8"
    "memory" = "4096"
  }
}

variable "pulsar" {
  type = "map"
  default = {
    "manager" = "pbs"
    "staging_directory" = "/storage/brno11-elixir/home/galaxyeu/galaxy-staging"
    "tool_dependency_directory" = "/storage/brno11-elixir/home/galaxyeu/galaxy-tools"
    "directory" = "/storage/brno11-elixir/home/galaxyeu/pulsar"
    "pbs_job_destination" = "galaxyeu"
  }
}
