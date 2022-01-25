
variable "subnet_ids" {
  description = "VPC subnet IDs"
  #type = "map"
  default = {
    subnet1 = ""
    subnet2 = ""
    subnet3 = ""
  }
}

variable "cluster_name" {
  default = "test-msk"
}

variable "kafka_version" {
  default = "2.8.0"
}

variable "number_of_broker_nodes" {
  default = "3"
}

variable "instance_type" {
  default = "kafka.t3.small"
}

variable "ebs_volume_size" {
  default = "50"
}

variable "encryption_at_rest_kms_key_arn" {
  description = "You may specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest."
  type        = string
  default     = ""
}

variable "encryption_in_transit_client_broker" {
  description = "Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT. Default value is TLS_PLAINTEXT."
  type        = string
  default     = "PLAINTEXT"
}

variable "encryption_in_transit_in_cluster" {
  description = "Whether data communication among broker nodes is encrypted. Default value: true."
  type        = bool
  default     = true
}

variable "ports" {
  type = map(number)
  default = {
    http = 8080
  }
}

variable "aws_api_gateway_rest_api_name"{
  type = string
  description = "test-api"
}

variable "stage_name" {
  type = string
  description = "test"
}