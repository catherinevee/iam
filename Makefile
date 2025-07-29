.PHONY: help init plan apply destroy validate fmt clean test

# Default target
help:
	@echo "Available commands:"
	@echo "  init     - Initialize Terraform"
	@echo "  plan     - Show Terraform plan"
	@echo "  apply    - Apply Terraform changes"
	@echo "  destroy  - Destroy Terraform resources"
	@echo "  validate - Validate Terraform configuration"
	@echo "  fmt      - Format Terraform code"
	@echo "  clean    - Clean up Terraform files"
	@echo "  test     - Run tests"

# Initialize Terraform
init:
	terraform init

# Show Terraform plan
plan:
	terraform plan

# Apply Terraform changes
apply:
	terraform apply

# Destroy Terraform resources
destroy:
	terraform destroy

# Validate Terraform configuration
validate:
	terraform validate

# Format Terraform code
fmt:
	terraform fmt -recursive

# Clean up Terraform files
clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup

# Run tests (placeholder for future test implementation)
test:
	@echo "Running tests..."
	@echo "Tests not implemented yet"

# Show current Terraform state
state:
	terraform show

# List Terraform resources
list:
	terraform state list

# Refresh Terraform state
refresh:
	terraform refresh

# Output Terraform outputs
output:
	terraform output

# Show Terraform version
version:
	terraform version

# Show provider versions
providers:
	terraform providers 