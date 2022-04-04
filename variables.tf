variable "default_values" {
  description = "Set all default values"
  type        = map(string)
  default = {
    project     = "personal",
    business    = "testing",
    environment = "dev",
    version     = "1.21"
  }
}
