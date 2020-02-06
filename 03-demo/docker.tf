locals {
  docker_registry_host     = "mycoolregistry.io"
  docker_registry_email    = "myemail@mycompany.com"
}

data "aws_secretsmanager_secret" "docker_registry_username" {
  name = var.docker_registry_username
}

data "aws_secretsmanager_secret_version" "docker_registry_password" {
  secret_id = data.aws_secretsmanager_secret.docker_registry_username.id
}

data "template_file" "docker_creds_inner" {
  template = file("${path.module}/files/docker-creds-inner.json.tpl")
  count    = length(var.docker_prefixes)

  vars = {
    docker_registry_host = local.docker_registry_host
    docker_prefix        = var.docker_prefixes[count.index]
    username             = var.docker_registry_username
    password             = data.aws_secretsmanager_secret_version.docker_registry_password.secret_string
    email                = local.docker_registry_email

    auth = base64encode(
      format(
        "%v:%v",
        var.docker_registry_username,
        data.aws_secretsmanager_secret_version.docker_registry_password.secret_string,
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

resource "kubernetes_secret" "docker_registry_secret" {
  type = "kubernetes.io/dockerconfigjson"

  metadata {
    name = "docker-secrets"
  }

  data = {
    ".dockerconfigjson" = data.template_file.docker_creds_outer.rendered
  }
}
