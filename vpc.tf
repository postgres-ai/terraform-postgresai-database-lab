/**
 * Establish & Configure the AWS VPC that the DLE
 * and other Postgres.ai products will reside within
 */

# Note that for now, we are simply adopting the default
# VPC. Future work should establish independent and dedicated
# VPC for Database Lab Engine.

resource "aws_default_vpc" "dle_vpc" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnet_ids" "dle_vpc_subnets" {
  vpc_id = aws_default_vpc.dle_vpc.id
}
