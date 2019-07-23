include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../../management/access",
    "../../management/network", 
    "../../management/servers",
    "../../management/server_attachment",
    "../../tenant/servers",
  ]
}