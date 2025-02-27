# Terraform Variable Precedence (highest to lowest priority)

1. -var or -var-file command line flags
2. *.auto.tfvars or *.auto.tfvars.json (alphabetical order)
3. terraform.tfvars.json
4. terraform.tfvars
5. environment variables (TF_VAR_*)
6. default value in variable declaration

# Example summary:
# Command line overrides files, which override env vars, which override defaults
