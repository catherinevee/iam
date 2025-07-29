.PHONY: help init plan apply destroy validate fmt lint clean test examples

# Default target
help:
	@echo "Available targets:"
	@echo "  init      - Initialize Terraform"
	@echo "  plan      - Plan Terraform changes"
	@echo "  apply     - Apply Terraform changes"
	@echo "  destroy   - Destroy Terraform resources"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  fmt       - Format Terraform code"
	@echo "  lint      - Lint Terraform code"
	@echo "  clean     - Clean Terraform state and cache"
	@echo "  test      - Run tests"
	@echo "  examples  - Test examples"

# Initialize Terraform
init:
	terraform init

# Plan Terraform changes
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

# Lint Terraform code (requires tflint)
lint:
	@if command -v tflint >/dev/null 2>&1; then \
		tflint --init; \
		tflint; \
	else \
		echo "tflint not found. Install from https://github.com/terraform-linters/tflint"; \
	fi

# Clean Terraform state and cache
clean:
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate*

# Run tests (requires terratest)
test:
	@if [ -d "test" ]; then \
		cd test && go test -v -timeout 30m; \
	else \
		echo "No tests found in test/ directory"; \
	fi

# Test examples
examples:
	@echo "Testing basic example..."
	@cd examples/basic && terraform init && terraform validate
	@echo "Testing advanced example..."
	@cd examples/advanced && terraform init && terraform validate
	@echo "All examples validated successfully!"

# Security scan (requires terrascan)
security-scan:
	@if command -v terrascan >/dev/null 2>&1; then \
		terrascan scan -i terraform; \
	else \
		echo "terrascan not found. Install from https://github.com/tenable/terrascan"; \
	fi

# Documentation
docs:
	@echo "Generating documentation..."
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table . > README.md.tmp; \
		echo "Documentation generated in README.md.tmp"; \
	else \
		echo "terraform-docs not found. Install from https://github.com/terraform-docs/terraform-docs"; \
	fi

# Pre-commit checks
pre-commit: fmt validate lint
	@echo "Pre-commit checks completed successfully!"

# CI/CD pipeline
ci: init validate fmt lint security-scan
	@echo "CI/CD pipeline completed successfully!" 