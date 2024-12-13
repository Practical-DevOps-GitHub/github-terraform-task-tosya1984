provider "github" {
  token = var.github_token
}

# Create GitHub repository
resource "github_repository" "repo" {
  name        = var.repository_name
  description = "Repository configured with Terraform"
  private     = true
  
  # Default branch
  default_branch = "develop"
}

# Add collaborator
resource "github_repository_collaborator" "collaborator" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

# Branch protection for "main"
resource "github_branch_protection" "main" {
  repository    = github_repository.repo.name
  branch        = "main"
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews = false
    require_code_owner_reviews = true
    required_approving_review_count = 1
  }
}

# Branch protection for "develop"
resource "github_branch_protection" "develop" {
  repository    = github_repository.repo.name
  branch        = "develop"

  required_pull_request_reviews {
    dismiss_stale_reviews = false
    require_code_owner_reviews = false
    required_approving_review_count = 2
  }
}

# Add CODEOWNERS file
resource "github_repository_file" "codeowners" {
  repository = github_repository.repo.name
  file       = ".github/CODEOWNERS"
  content    = "* @softservedata"
  branch     = "main"
}

# Add pull request template
resource "github_repository_file" "pull_request_template" {
  repository = github_repository.repo.name
  file       = ".github/pull_request_template.md"
  content    = <<EOT
Describe your changes

Issue ticket number and link

Checklist before requesting a review:
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
  branch = "develop"
}

# Add deploy key
resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = var.deploy_key
  read_only  = false
}

# Add PAT to repository secrets
resource "github_actions_secret" "pat" {
  repository = github_repository.repo.name
  secret_name = "PAT"
  plaintext_value = var.personal_access_token
}

# Discord notification setup
resource "github_repository_webhook" "discord" {
  repository = github_repository.repo.name
  name       = "web"

  configuration {
    url          = var.discord_webhook_url
    content_type = "json"
  }

  events = ["pull_request"]
}

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
