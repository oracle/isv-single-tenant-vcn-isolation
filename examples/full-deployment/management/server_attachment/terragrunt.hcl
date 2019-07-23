include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../../management/network", 
    "../../management/servers",
    "../../peering/network",
    "../../tenant/network",
  ]
}
