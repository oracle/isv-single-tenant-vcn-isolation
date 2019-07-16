/* Load Balancer */

resource "oci_load_balancer" "lb1" {
  shape          = var.shape
  compartment_id = "${var.compartment_id}"

  subnet_ids = [ var.subnet_id ]

  display_name = var.display_name
}

resource "oci_load_balancer_backend_set" "lb-bes1" {
  name             = "${var.display_name}-backendset"
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    url_path            = "/"
    return_code         = "200"
  }
}

resource "oci_load_balancer_listener" "lb-listener1" {
  load_balancer_id         = "${oci_load_balancer.lb1.id}"
  name                     = "http"
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-bes1.name}"
  port                     = 80
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "30"
  }
}

resource "oci_load_balancer_backend" "lb-be1" {
  load_balancer_id = "${oci_load_balancer.lb1.id}"
  backendset_name  = "${oci_load_balancer_backend_set.lb-bes1.name}"
  ip_address       = var.management_private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}


