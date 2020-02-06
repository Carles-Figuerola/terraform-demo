locals {
  docker_registry_host     = "mycoolregistry.io"
  docker_registry_password = "mysecretpassword"
  docker_registry_email    = "myemail@mycompany.com"
}

data "template_file" "docker_creds" {
  template = file("${path.module}/files/docker-creds.json.tpl")

  vars = {
    docker_registry_host = local.docker_registry_host
    username             = var.docker_registry_username
    password             = local.docker_registry_password
    email                = local.docker_registry_email

    auth = base64encode(
      format(
        "%v:%v",
        var.docker_registry_username,
        local.docker_registry_password,
      ),
    )
  }
}

output "rendered" {
  value = "${data.template_file.docker_creds.rendered}"
}
