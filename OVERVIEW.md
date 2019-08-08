
## Solution Overview

The objective of this solution is to provide an architecture and sample solution deployment for deploying multiple isolated application deployments in separate VCNs securely connected back to a common management VCN, within a single OCI tenancy 

Management of multiple isolated application deployments is a common requirement for ISVs that are moving traditional on-premisis ISV applications to the Cloud.  These applications may have historically been designed for, and deployed within, the end customers data center and managed by the customers IT organization.  As enterprises are moving their IT workloads to the Cloud they are looking to consume these same applications from their vendors in a managed SaaS model.

## Solution Architecture

The high level architecture pattern to allow ISVs to securely deploy mutiple end customer applications, or application tenants, into a single OCI tenany managed by the ISV, is to segregate the deployment using **Network** isolation. Each application tenant deployed into a separate VCN. By default each VCN is fully isolated for all other VCNs and access to other networks icnluding the Internet, external private networks, and other VCNs is controlled using **Gateways**

- **Internet Gateway** and **NAT Gateway** for internet access
- **Dynamic Routing Gateway** for external private connection over IPSEC or FastConnect
- **Local Peering Gateway** for conectivity between VCNs in the same OCI Tenany and Region.

Conspetually the general deployment pattern would be:

TODO: ADD DIAGRAM

`ISV <-IGW/DRG-> MANAGEMENT VCN <-LPG->|<-LPG-> TENANT 1 VCN <-IGW/DRG-> END CUSTOMER`

### Requirements

- The soloution does not impose any limitations on the ISV connectivity into the OCI tenancy. i.e. the ISV may connect via a public bastion host, or a private connection (VPN or FastConnect).

- The solution does not impose any limitations on end customer access options to the tenant application deployment. i.e. end customers could be accessing the application over the public internet or via a private connection (VPN or FastConnect).

- Network connectivity allows instnaces in the ISVs managment network to securely connect to instances in each tenant network

- Network connectivity allows instances in the tenant network to securely connect back to the management applications

### Assumptions

- Each tenant deployment uses non-overlapping network addressing, i.e all tenant networks have an separate unique address space. 

### Overcoming VCN Peering Limits

The number of Local Peering Gateways that can be created in a VCN is limited to 10 [TODO: ADD DOCUMENT REFERENCE](). Using the conceptual architecture described above a deployment would be limited to supporting a maximum of 10 end customers through VCN local peering.

To scale out the solution to support a much larger number of isolated application tenants in separate VCNs we introduce additional intermidary peering networks to group multiple tenants. Each peering network can connect to up to 10 tenant VCNs through the Local Peering Gateways, and connective back to management network through a networking instance to route traffic between the management and the peering networks.

The routing function can be handled by an appropriately configured Oracle Linux instance, or the solution could be adapted to use a thrid party network appliance.  

The routing instance is deployed in the management network with a secondary vnic on the instance provisioned in a subnet of the peering VNC that has the Local Peering Connections to the Tenent VCNs.  To enable routing of network traffic through the instance the all the routing instance vNICs must be created with the `skip_source_dest_check` option enabled.

The scalable VCN peering architecture now looks like:

TODO: ADD DIAGRAM

`MANAGEMENT SUBNET <-> PEERING SUBNET <-> ROUTING INSTANCE `

The number of Peering VCNs that can been connected to a single routing instance is dependent of the instance Shape. e.g. 

- a `VM.Standard2.1` shape instance can have a **maximum of 2 vNICs**, the primary vNIC and one secondary vNIC which means the routing instance can connect to just one peering VCN, connecting up to a **maximum of 10 tenant VCNs**.

- a `VM.Standard2.4` shape instance can have a **maximum of 4 vNICs**, the primary vNIC and three secondary vNICs which means the routing instance can connect to three peering VCNs, connecting up to a **maximum of 30 tenant VCNs**.

- a `VM.Standard2.24` shape instance can have a **maximum of 24 vNICs**, the primary vNIC and twenty three secondary vNICs which means the routing instance can connect to three peering VCNs, connecting up to a **maximum of 230 tenant VCNs**.

Multiple routing instances can be deployed to futher scale up to the OCI Tenancy VCN Limit.

### Bandwidth considerations

The maximum available bandwidth through the routing instance is also a factor of the instance shape.  The total bandwidth available, which scales with the shape, is shared across all vNICs of the instance. Consideration should be given to the total bandwidth requirements needed between the management and tenant networks, and the potential impact of bandwidth starvation is one tenant connection is consuming the available bandwidth.

The use of traffic shaping or third party routing appliances could be considered, but this beyond the current scope of this solution architecture.

### Why not connect the routing instances directly to the tenant VCNs?

While an approach could be taken to connect each tenant VCN directly to the routing instance, the indirection though the local peering gateway to the peering network provides a more managable deployment, all the resource and security policies for managing the peer routing can be contained within the peering compartment, eliminating the need to manage the foreign routing instance vNIC in the tenant network/compartment. 

Additionally the ability to peer multiple tenants, up to the maximum 10 local peering gateways, trhough the peering VCN to secondary vNIC on the routing instance can provide up to 10x better utilization of the routing instances resources, lowering the total overhead costs of the solution deployment.

## High Availability Routing Instance Pattern

General networking, including connectivity between the VCNs using Local Peering Gateways, is a core part of OCI and high availablity of these resources is built into the underlying OCI infrastrcture.

The introduction of the routing instances adds a networking dependency that is outside the direct control of the underlying OCI network, and becomes a potential single point of failure in the solution deployment

High availablity for the routing instances can be achivied by deploying the instances in primary and active standby pairs in separate fault domains, and with floating private IPs (VIPs) that can be moved from the primary to the secondary routing instance in the event of a failure.

The network routing is configured using the floating IPs.  To fail over the from the primary to the secondard routing instance the floating private IPs are moved to the vNICs of the secondary instance.

TODO: Diagram

The sample solution deployment includes a high availability deployment of the routing instances using Pacemaker and Corosync. The automated fail over runs the commands to move the private IPs using the OCI CLI.  Instance Principles [TODO ADD REFERNCE]() are configured to allow the routing instances to modify the vNICs and Private IPs in the Peering compartmetn through through the CLI.

## Compartment Structure

Compartments are used to both logically group resources and to setting security permissions that only allow specific IAM roles to deploy and modify resources within the specific compartments.

The baseline architecture uses the following compartment structure

- **root compartment** - this is an existing compartment that could be the OCI tenancy root compartment, or an application specific compartment. All the solutions compartments and the IAM policies are set in this compartment. 

- **management compartment** - created in the provided root compartment, this compartment is used for all resources that are part of the management infrastructure.

- **peering compartment** - created in the root compartment, the peering compartment is specific to this solution architecture and used for grouping all resource related to the secure scale-out peering infrastructure including the peering networks and the routing resources to peer the tenant networks to the managament infrastrcture.

- **tenant compartments** - multiple compartments created in root compartment, one for each application tenant deployment.  The tenant compartments contain all the resources for the deployment 


TODO: DIAGRAM


## Sizing and Scaling Considertions

- Total Number of Application Tenants [1..???].  Must be within the maximum VCN limit for the tenancy. 

- Number of Tenant VCNs per Peering VCN [1..10].  This affects the number of local peering gateways per peering vcn, up to the maximum of 10.

- Number of Peering VCNs per Routing Instance [1..51]. This affect the choice of routing instance shape, up the maximum number of secondard vNICs that can be configured for the selected shape.

- Maximum and average Management Network Bandwidth per Tenant. The maximum available bandwidth between the tenant and the management network is a factor of the Routing Instance Shape. The availabile bandwidth is shared across all vNICs.  This factor will influence both the shape selection and the number of Peering VCNs per routing instance 

