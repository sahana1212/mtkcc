variable "key_name" {
  default = "master-key"
}

variable "pvt_key" {
  default = "/var/lib/jenkins/master-key.pem"
}

variable "us-east-zones" {
  default = ["eu-central-1"]
}

variable "sg-id" {
  default = "sg-0f6df36a07c37a0bc"
}
