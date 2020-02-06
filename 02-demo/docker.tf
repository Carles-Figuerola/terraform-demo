locals {
  docker_registry_host     = "mycoolregistry.io"
  docker_registry_password = "mysecretpassword"
  docker_registry_email    = "myemail@mycompany.com"
}

data "template_file" "docker_creds_inner" {
  template = file("${path.module}/files/docker-creds-inner.json.tpl")
  count    = length(var.docker_prefixes)

  vars = {
    docker_registry_host = local.docker_registry_host
    docker_prefix        = var.docker_prefixes[count.index]
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

data "template_file" "docker_creds_outer" {
  template = file("${path.module}/files/docker-creds-outer.json.tpl")

  vars = {
    data = join(",\n", data.template_file.docker_creds_inner.*.rendered)
  }
}

output "rendered" {
  value = data.template_file.docker_creds_outer.rendered
}
