variable "docker_prefixes" {
  type        = list(string)
  description = "List of subdomains to auth in docker. eg. team1"
  default     = ["team1", "team2", "team3"]
}

variable "docker_registry_username" {
  type    = string
  default = "my-serviceaccount"
}
