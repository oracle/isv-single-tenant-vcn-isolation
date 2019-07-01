
dependencies: secondary_vnic_all_configure.sh id_rsa

secondary_vnic_all_configure.sh:
	curl -o secondary_vnic_all_configure.sh https://docs.cloud.oracle.com/iaas/Content/Resources/Assets/secondary_vnic_all_configure.sh

id_rsa:
	ssh-keygen -q -N "" -f ~/.ssh/id_rsa