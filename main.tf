data "template_file" "pulsar" {
  template = "${file("templates/meta-pulsar-pbs.tpl")}"
  vars {
    CPU = "${var.one["cpu"]}"
    VCPU = "${var.one["vcpu"]}"
    MEMORY = "${var.one["memory"]}"
    IMAGE = "${var.one["image"]}"
    IMAGE_UNAME = "${var.one["image_uname"]}"
    IMAGE_SIZE = "${var.one["image_size"]}"
    SWAP_IMAGE = "${var.one["swap_image"]}"
    SWAP_IMAGE_UNAME = "${var.one["swap_image_uname"]}"
    NETWORK = "${var.one["public_network"]}"
    NETWORK_UNAME = "${var.one["public_network_uname"]}"
    NETWORK_SG = "${var.one["security_group"]}"
  }
}

resource "opennebula_template" "pulsar" {
  name = "meta-galaxy-pulsar"
  description = "${data.template_file.pulsar.rendered}"
  permissions = "600"
}

resource "opennebula_vm" "pulsar" {
  template_id = "${opennebula_template.pulsar.id}"
  permissions = "600"
  connection {
    host = "${self.ip}"
    agent = true
  }
  provisioner "local-exec" {
    command = "until ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${self.ip} test -e /root/ready; do sleep 5; done"
  }
  provisioner "ansible" {
    become = "yes"
    local = "yes"
    plays {
      playbook = "ansible/pulsar.yml"
      vault_password_file = "/root/.vault_pass"
      extra_vars {
        pulsar_manager = "${var.pulsar["manager"]}"
        pulsar_staging_directory = "${var.pulsar["staging_directory"]}"
        pulsar_tool_dependency_directory = "${var.pulsar["tool_dependency_directory"]}"
        pulsar_pbs_job_destination = "${var.pulsar["pbs_job_destination"]}"
        pulsar_bind_ip = "${self.ip}"
        pulsar_message_queue_url = "${var.pulsar["message_queue_url"]}"
        pulsar_directory = "${var.pulsar["directory"]}"
      }
    }
  }
}
