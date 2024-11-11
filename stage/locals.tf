
locals {
  ### Start of the List of Parameters for SGs in VPC ###
  main_sg = [
    {
      from_port   = "80"
      to_port     = "80"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP From Everywhere"
    },
    {
      from_port   = "443"
      to_port     = "443"
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS From Everywhere"
    }
  ]

  waf_site_whitelist = ["3.145.51.214/32", "3.122.230.138/32"]
}
