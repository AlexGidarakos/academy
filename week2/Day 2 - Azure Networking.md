# Microsoft Azure Networking

## VNets

1. What is a VNET and why is it used?
The fundamental building block for a private network in Azure
It's an implementation of a private network in Azure.
Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is similar to a traditional network that you'd operate in your own data center, but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.

Why use an Azure Virtual network?

Azure virtual network enables Azure resources to securely communicate with each other, the internet, and on-premises networks. Key scenarios that you can accomplish with a virtual network include - communication of Azure resources with the internet, communication between Azure resources, communication with on-premises resources, filtering network traffic, routing network traffic, and integration with Azure services.



2. What are the 2 types of VNet Peering and why are they used?

Azure supports the following types of peering:

    Virtual network peering: Connecting virtual networks within the same Azure region.
    Global virtual network peering: Connecting virtual networks across Azure regions.

The benefits of using virtual network peering, whether local or global, include:

    A low-latency, high-bandwidth connection between resources in different virtual networks.
    The ability for resources in one virtual network to communicate with resources in a different virtual network.
    The ability to transfer data between virtual networks across Azure subscriptions, Azure Active Directory tenants, deployment models, and Azure regions.
    The ability to peer virtual networks created through the Azure Resource Manager.
    The ability to peer a virtual network created through Resource Manager to one created through the classic deployment model. To learn more about Azure deployment models, see Understand Azure deployment models.
    No downtime to resources in either virtual network when creating the peering, or after the peering is created.



3. What do you need to assign in order to allow inbound traffic to a resource from the internet?

Network security rules (NSGs)

If you need basic network level access control (based on IP address and the TCP or UDP protocols), you can use Network Security Groups (NSGs). An NSG is a basic, stateful, packet filtering firewall, and it enables you to control access based on a 5-tuple. NSGs include functionality to simplify management and reduce the chances of configuration mistakes:

    Augmented security rules simplify NSG rule definition and allow you to create complex rules rather than having to create multiple simple rules to achieve the same result.
    Service tags are Microsoft created labels that represent a group of IP addresses. They update dynamically to include IP ranges that meet the conditions that define inclusion in the label. For example, if you want to create a rule that applies to all Azure storage on the east region you can use Storage.EastUS
    Application security groups allow you to deploy resources to application groups and control the access to those resources by creating rules that use those application groups. For example, if you have webservers deployed to the 'Webservers' application group you can create a rule that applies a NSG allowing 443 traffic from the Internet to all systems in the 'Webservers' application group.

NSGs do not provide application layer inspection or authenticated access controls.

Learn more:

    Network Security Groups




    
## Private/Public IP Addressing / Subnets

1. What are Private and Public IP Addresses?


Private IPs allow communication between resources in Azure.

Resources can be:

    Azure Services such as:
        Virtual machine network interfaces
        Internal load balancers (ILBs)
        Application gateways
    In a virtual network.
    On-premises network through a VPN gateway or ExpressRoute circuit.

Private IPs allow communication to these resources without the use of a public IP address.




Public IP addresses allow Internet resources to communicate inbound to Azure resources. Public IP addresses enable Azure resources to communicate to Internet and public-facing Azure services. The address is dedicated to the resource, until it's unassigned by you. A resource without a public IP assigned can communicate outbound. Azure dynamically assigns an available IP address that isn't dedicated to the resource. For more information about outbound connections in Azure, see Understand outbound connections.

In Azure Resource Manager, a public IP address is a resource that has its own properties.

The following resources can be associated with a public IP address:

    Virtual machine network interfaces

    Virtual Machine Scale Sets

    Public Load Balancers

    Virtual Network Gateways (VPN/ER)

    NAT gateways

    Application Gateways

    Azure Firewalls

    Bastion Hosts

    Route Servers



2. If I created a subnet range of 10.10.0.0/16, which reserved IP Addresses would be unavailable to allocate? What does the /nn mean?

Based on the subnet mask of 16 bits, we have 32 - 16 = 16 bits left for IP addresses, meaning 2^16 = 65536 IPs. Minus 5 allocated by Azure for network address (1), default gateway (1), DNS (2), broadcast (1), leaving 65531 IPs available.




## VPN gateway

1. What is Azure VPN Gateway?

Azure VPN Gateway is a service that uses a specific type of virtual network gateway to send encrypted traffic between an Azure virtual network and on-premises locations over the public Internet. You can also use VPN Gateway to send encrypted traffic between Azure virtual networks over the Microsoft network. Multiple connections can be created to the same VPN gateway. When you create multiple connections, all VPN tunnels share the available gateway bandwidth.


2. A VPN Gateway needs IP Addresses to use - what do you need to create in order to have IP Addresses available for the VPN Gateway?

A subnet and a public IP.



## DNS - Public & Private

1. What is Azure DNS?

Azure DNS is a hosting service for DNS domains that provides name resolution by using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records by using the same credentials, APIs, tools, and billing as your other Azure services.

You can't use Azure DNS to buy a domain name. For an annual fee, you can buy a domain name by using App Service domains or a third-party domain name registrar. Your domains then can be hosted in Azure DNS for record management. For more information, see Delegate a domain to Azure DNS.


2. [Public DNS Exercise](https://learn.microsoft.com/en-us/azure/dns/dns-getstarted-portal)

3. [Private DNS Exercise](https://learn.microsoft.com/en-us/azure/dns/private-dns-getstarted-portal)
alexg / iCw9R7Uk7qmzQzt



## Express Route (Theory)

1. What is Azure ExpressRoute?

ExpressRoute lets you extend your on-premises networks into the Microsoft cloud over a private connection with the help of a connectivity provider. With ExpressRoute, you can establish connections to Microsoft cloud services, such as Microsoft Azure and Microsoft 365.

Connectivity can be from an any-to-any (IP VPN) network, a point-to-point Ethernet network, or a virtual cross-connection through a connectivity provider at a colocation facility. ExpressRoute connections don't go over the public Internet. This allows ExpressRoute connections to offer more reliability, faster speeds, consistent latencies, and higher security than typical connections over the Internet. For information on how to connect your network to Microsoft using ExpressRoute, see ExpressRoute connectivity models.

Key benefits

    Layer 3 connectivity between your on-premises network and the Microsoft Cloud through a connectivity provider. Connectivity can be from an any-to-any (IPVPN) network, a point-to-point Ethernet connection, or through a virtual cross-connection via an Ethernet exchange.
    Connectivity to Microsoft cloud services across all regions in the geopolitical region.
    Global connectivity to Microsoft services across all regions with the ExpressRoute premium add-on.
    Dynamic routing between your network and Microsoft via BGP.
    Built-in redundancy in every peering location for higher reliability.
    Connection uptime SLA.
    QoS support for Skype for Business.



## Virtual Network Service Endpoints

1. What are Virtual Network Service Endpoints?

Virtual Network (VNet) service endpoint provides secure and direct connectivity to Azure services over an optimized route over the Azure backbone network. Endpoints allow you to secure your critical Azure service resources to only your virtual networks. Service Endpoints enables private IP addresses in the VNet to reach the endpoint of an Azure service without needing a public IP address on the VNet.

2. What are the benefits of using them?

Virtual Network (VNet) service endpoint provides secure and direct connectivity to Azure services over an optimized route over the Azure backbone network. Endpoints allow you to secure your critical Azure service resources to only your virtual networks. Service Endpoints enables private IP addresses in the VNet to reach the endpoint of an Azure service without needing a public IP address on the VNet.

Key benefits

Service endpoints provide the following benefits:

    Improved security for your Azure service resources: VNet private address spaces can overlap. You can't use overlapping spaces to uniquely identify traffic that originates from your VNet. Service endpoints enable securing of Azure service resources to your virtual network by extending VNet identity to the service. Once you enable service endpoints in your virtual network, you can add a virtual network rule to secure the Azure service resources to your virtual network. The rule addition provides improved security by fully removing public internet access to resources and allowing traffic only from your virtual network.

    Optimal routing for Azure service traffic from your virtual network: Today, any routes in your virtual network that force internet traffic to your on-premises and/or virtual appliances also force Azure service traffic to take the same route as the internet traffic. Service endpoints provide optimal routing for Azure traffic.

    Endpoints always take service traffic directly from your virtual network to the service on the Microsoft Azure backbone network. Keeping traffic on the Azure backbone network allows you to continue auditing and monitoring outbound Internet traffic from your virtual networks, through forced-tunneling, without impacting service traffic. For more information about user-defined routes and forced-tunneling, see Azure virtual network traffic routing.

    Simple to set up with less management overhead: You no longer need reserved, public IP addresses in your virtual networks to secure Azure resources through IP firewall. There are no Network Address Translation (NAT) or gateway devices required to set up the service endpoints. You can configure service endpoints through a single selection on a subnet. There's no extra overhead to maintaining the endpoints.


3. What services support Endpoints?

Service endpoints are available for the following Azure services and regions. The Microsoft.* resource is in parenthesis. Enable this resource from the subnet side while configuring service endpoints for your service:

Generally available

    Azure Storage (Microsoft.Storage): Generally available in all Azure regions.
    Azure SQL Database (Microsoft.Sql): Generally available in all Azure regions.
    Azure Synapse Analytics (Microsoft.Sql): Generally available in all Azure regions for dedicated SQL pools (formerly SQL DW).
    Azure Database for PostgreSQL server (Microsoft.Sql): Generally available in Azure regions where database service is available.
    Azure Database for MySQL server (Microsoft.Sql): Generally available in Azure regions where database service is available.
    Azure Database for MariaDB (Microsoft.Sql): Generally available in Azure regions where database service is available.
    Azure Cosmos DB (Microsoft.AzureCosmosDB): Generally available in all Azure regions.
    Azure Key Vault (Microsoft.KeyVault): Generally available in all Azure regions.
    Azure Service Bus (Microsoft.ServiceBus): Generally available in all Azure regions.
    Azure Event Hubs (Microsoft.EventHub): Generally available in all Azure regions.
    Azure Data Lake Store Gen 1 (Microsoft.AzureActiveDirectory): Generally available in all Azure regions where ADLS Gen1 is available.
    Azure App Service (Microsoft.Web): Generally available in all Azure regions where App service is available.
    Azure Cognitive Services (Microsoft.CognitiveServices): Generally available in all Azure regions where Cognitive services are available.

Public Preview

    Azure Container Registry (Microsoft.ContainerRegistry): Preview available in limited Azure regions where Azure Container Registry is available.

For the most up-to-date notifications, check the Azure Virtual Network updates page.


## Azure Security: Security centre, KeyVaults, NSGs etc

[https://learn.microsoft.com/en-us/azure/security/fundamentals/overview](https://learn.microsoft.com/en-us/azure/security/fundamentals/overview)

1. What is KeyVault? What are the 3 object types you can store?

Azure Key Vault is a cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys. Key Vault service supports two types of containers: vaults and managed hardware security module(HSM) pools. Vaults support storing software and HSM-backed keys, secrets, and certificates. Managed HSM pools only support HSM-backed keys. See Azure Key Vault REST API overview for complete details.

2. [Exercise](https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-portal)

AlexgSecret1
AlexgSecret1Value

3. What is an NSG?

A Network Security Group (NSG) is a basic stateful packet filtering firewall and it enables you to control access based on a 5-tuple. NSGs do not provide application layer inspection or authenticated access controls. They can be used to control traffic moving between subnets within an Azure Virtual Network and traffic between an Azure Virtual Network and the Internet.

4. [Exercise](https://learn.microsoft.com/en-us/azure/virtual-network/tutorial-restrict-network-access-to-resources)



## Azure landing zone  - Hub/spoke setup and sharing components between services

1. What is an Azure landing zone? [Video](https://www.microsoft.com/en-us/videoplayer/embed/RE4xdvm?postJsllMsg=true)

2. What is Hub and Spoke?

## Azure firewalls

1. How many sku types of Azure Firewall are there and what are the differences between them?

## Azure Frontdoor

1. What is Azure Front Door?

2. [Bonus exercise](https://learn.microsoft.com/en-us/azure/frontdoor/quickstart-create-front-door)
