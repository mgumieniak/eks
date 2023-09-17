resource "aws_network_acl" "public_nacl" {
  vpc_id = var.vpc_id
  subnet_ids = aws_subnet.public_k8s_subnet.*.id

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.name}_public_nacl"
    Environment = var.environment
  }
}

resource "aws_network_acl" "private_nacl" {
  vpc_id = var.vpc_id
  subnet_ids = aws_subnet.private_k8s_subnet.*.id

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.name}_private_nacl"
    Environment = var.environment
  }
}

