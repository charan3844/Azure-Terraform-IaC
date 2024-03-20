# A variables.tf file is used to define the variables and optionally set a default value
variable "prefix" {
  type        = string
  description = "prefix"
  default     = ""
}

variable "rgname" {
  type        = string
  description = "The name of the subnet"
  default     = ""
}

variable "rglocation" {
  type        = string
  description = "The name of the subnet"
  default     = ""  //-entire  while apply command / "value" - it will take it directly
}

variable "vnetname" {
  type        = string
  description = "The name of the subnet"
  default     = ""
}

variable "subnetname" {
  type        = string
  description = "The name of the subnet"
  default     = ""
}

variable "vmname" {
  type        = string
  description = "name of the vm"
  default     = ""
}

variable "vnet_ip_address_space" {
  type        = string
  description = "IP address space of the vnet"
  default     = ""
}

variable "subnet_ip_address_prefix" {
  type        = string
  description = "IP address prefix of the subnet"
  default     = ""
}

variable "vm_public_ip" {
  type        = string
  description = "Public IP Address name"
  default     = ""
}

variable "privatenic" {
  type        = string
  description = "Private IP Address name"
  default     = ""
}

variable "vmsize" {
  type        = string
  description = "name of the vm size"
  default     = ""
}

variable "manageddiskname" {
  type        = string
  description = "name of the datadiskname"
  default     = ""
}

variable "nsg" {
  type        = string
  description = "name of the nsgrule"
  default     = ""
}

variable "username" {
  type        = string
  description = "user name of the vm"
  default     = ""
}

variable "pswd" {
  type        = string
  description = "pswd ame of the vm"
  default     = ""
}

