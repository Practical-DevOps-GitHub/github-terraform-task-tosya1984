variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "repository_name" {
  description = "github-terraform-task-tosya1984"
  type        = string
}

variable "deploy_key" {
  description = "Deploy key for the repository"
  type        = string
}

variable "personal_access_token" {
  description = "Personal Access Token for GitHub Actions"
  type        = string
}

variable "discord_webhook_url" {
  description = "Discord Webhook URL for notifications"
  type        = string
}
