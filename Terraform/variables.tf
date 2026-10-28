variable "subscription_id" {
  description = "Azure Subscription ID. No se publica con valor real en GitHub."
  type        = string
}

variable "client_id" {
  description = "Application/Client ID del Service Principal."
  type        = string
}

variable "client_secret" {
  description = "Secreto del Service Principal."
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant/Directory ID."
  type        = string
}

variable "sql_admin_password" {
  description = "Contrasena del administrador SQL usado por Terraform."
  type        = string
  sensitive   = true
}
