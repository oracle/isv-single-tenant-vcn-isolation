
TF_CONFIGS = common/configuration \
		common/compartments \
       management/network \
       peering/network \
			 tenant/network \
			 management/access \
			 peering/routing \
			 management/servers \
			 management/server_attachment \
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
		(cd $$c && terraform init -upgrade); \
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

clean:
	# remove all .terraform config directories
	@for c in $(TF_CONFIGS); \
	do \
		echo $$c; \
		(cd $$c && rm -rf .terraform); \
	done

.PHONY: fmt init upgrade validate apply destroy clean
