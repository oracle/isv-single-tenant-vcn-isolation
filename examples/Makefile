TF_CONFIGS = management/application \
			 management/network \
			 management/server_attachment \
			 management/servers \
			 peering/network \
			 tenant/application \
			 tenant/network \
			 tenant/servers


default: init apply

terraform.tfvars:
	@echo "./terraform.tfvars not found. Exiting."
	@exit 1

init:
	# run terraform init across all configs
	@for c in $(TF_CONFIGS); \
	do \
		(cd $$c && terraform init); \
	done

upgrade:
	# run terraform init -upgrade across all configs
	@for c in $(TF_CONFIGS); \
	do \
		(cd $$c && terraform init -upgrade); \
	done

apply: terraform.tfvars
	# use terragrunt to apply all configutations
	@echo y | terragrunt apply-all

destroy: terraform.tfvars
	# use terragrunt to destroy all configurations
	@echo y | terragrunt destroy-all

.PHONY: init upgrade apply destroy