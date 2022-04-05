.PHONY: all plan apply destroy

all: help

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# If running locally, you might need to define the AWS environment variables:
# export AWS_ACCESS_KEY_ID=""
# export AWS_SECRET_ACCESS_KEY=""
# export AWS_SESSION_TOKEN=""
# export AWS_DEFAULT_REGION=""

help: ## Show this simple help table.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/## //;s/:/\t\t\t/'

init: ## Initialize a new or existing Terraform working directory by creating initial files, loading any remote state, downloading modules, etc.
	terraform init -backend-config=s3-dev.tfbackend -no-color

valid: ## Verify whether a configuration is syntactically valid and internally consistent.
	terraform validate -no-color

fmt: ## Checks that all Terraform configuration files complies with the canonical format.
	terraform fmt -check -diff -no-color

plan: ## Generates an execution plan for Terraform to preview changes in the infrastructure.
	terraform plan -var-file=vars-dev.tfvars -no-color -out=plan.out

apply: ## Change infrastructure according to Terraform configuration files.
	terraform apply -no-color plan.out

pland: ## Generates an execution plan for Terraform to preview changes in the infrastructure (Plan Destroy).
	terraform plan -destroy -var-file=vars-dev.tfvars -no-color

destroy: ## Destroy the created infrastructure.
	terraform destroy -auto-approve -var-file=vars-dev.tfvars -no-color

ifndef AWS_DEFAULT_REGION
	$(error AWS_DEFAULT_REGION is not defined. Make sure that you set your AWS region.)
endif
