module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "2.10.0"

  connect_to_transit_gateway = true
  transit_gateway_id         = module.tgw.ec2_transit_gateway_id
  customer_gateway_id        = module.vpc.cgw_ids[0]

  # tunnel inside cidr & preshared keys (optional)
  tunnel1_inside_cidr   = var.custom_tunnel1_inside_cidr
  tunnel2_inside_cidr   = var.custom_tunnel2_inside_cidr
  tunnel1_preshared_key = var.custom_tunnel1_preshared_key
  tunnel2_preshared_key = var.custom_tunnel2_preshared_key
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  enable_vpn_gateway = true
  amazon_side_asn    = 64620

  customer_gateways = {
    IP1 = {
      bgp_asn    = 65220
      ip_address = "172.83.124.10"
    },
    IP2 = {
      bgp_asn    = 65220
      ip_address = "172.83.124.11"
    }
  }

  # ...
}

module "tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "~2.4.0"

  name            = "my-tgw"
  description     = "My TGW shared with several other AWS accounts"
  amazon_side_asn = 64532

  vpc_attachments = {
    vpc1 = {
      vpc_id      = "vpc-12345678"                        # module.vpc.vpc_id <- will not work since computed values can't be used in `count`
      subnet_ids  = ["subnet-123456", "subnet-111222233"] # module.vpc.public_subnets <- will not work since computed values can't be used in `count`
      dns_support = true

      tgw_routes = [
        {
          destination_cidr_block = "30.0.0.0/16"
        },
        {
          blackhole              = true
          destination_cidr_block = "0.0.0.0/0"
        }
      ]
    }
  }
}
