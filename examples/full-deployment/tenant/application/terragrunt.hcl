include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../../tenant/network", 
    "../../tenant/servers",
    "../../management/access",
    "../../management/network",
    "../../management/servers",
    "../../management/server_attachment"
  ]
}