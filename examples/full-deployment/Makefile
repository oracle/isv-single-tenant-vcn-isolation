TF_CONFIGS = management/access \
			 management/application \
			 management/network \
			 management/server_attachment \
			 management/servers \
			 peering/network \
			 peering/routing \
			 tenant/application \
			 tenant/network \
			 tenant/servers


default: init apply

terraform.tfvars:
	@echo "./terraform.tfvars not found. Exiting."
	@exit 1

fmt:
	# run terraform fmt across all configs
	@for c in $(TF_CONFIGS); \
	do \
		echo $$c; \
		(cd $$c && terraform fmt); \
	done

init:
	# run terraform init across all configs
	@for c in $(TF_CONFIGS); \
	do \
		echo $$c; \
		(cd $$c && terraform init); \
	done

upgrade:
	# run terraform init -upgrade across all configs
	@for c in $(TF_CONFIGS); \
	do \
		echo $$c; \
		(&& cd $$c && terraform init -upgrade); \
	done

validate:
	# run terraform validate across all configs
	@for c in $(TF_CONFIGS); \
	do \
		echo $$c; \
		(cd $$c && terraform validate); \
	done

apply: terraform.tfvars
	# use terragrunt to apply all configutations
	@echo y | terragrunt apply-all

destroy: terraform.tfvars
	# use terragrunt to destroy all configurations
	@echo y | terragrunt destroy-all

.PHONY: fmt init upgrade validate apply destroy