# actual access key
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  default     = "abcdefgh" # provided access key
}
# actual secret key
variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  default     = "rew24w3wer4" # provided secret key
}
# setting variables of subnets
variable "AWS_PUBLIC_SUBNET_A" {
  description = "The ID of public subnet A"
  default     = "subnet-55555555555"
}
variable "AWS_PUBLIC_SUBNET_B" {
  description = "The ID of public subnet B"
  default     = "subnet-66666666666"
}
variable "AWS_PUBLIC_SUBNET_C" {
  description = "The ID of public subnet C"
  default     = "subnet-77777777777"
}
variable "AWS_PUBLIC_SUBNET_D" {
  description = "The ID of public subnet D"
  default     = "subnet-88888888888"
}
# provided certificate
variable "AWS_ACM_CERT_ARN" {
  description = "The ARN of the AWS ACM certificate"
  type        = string
  default     = "AWS_ACM_CERT_ARN=arn:aws:acm:us-east-1:99999999999:certificate/4dd9207certificate/4dd92072-a3ed-40b1-9f09-0b968d7c6043"
}
