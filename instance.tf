resource "aws_instance" "public_instance" {
  ami                         = "ami-06e46074ae430fba6"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "project_key"
  vpc_security_group_ids      = [aws_security_group.pub_sec_group.id]
  subnet_id                   = aws_subnet.public[1].id
  tags = {
    Name = "${var.env_prefix}-pub_instance"
  }
}

resource "aws_security_group" "pub_sec_group" {
  name        = "${var.env_prefix}-sec_group"
  description = "Allow ssh inbound "
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["108.216.6.65/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-public_sec_group"
  }
}




resource "aws_instance" "private_instance" {
  ami                         = "ami-06e46074ae430fba6"
  instance_type               = "t2.micro"
  key_name                    = "project_key"
  vpc_security_group_ids      = [aws_security_group.private_sec_group.id]
  subnet_id                   = aws_subnet.private[1].id
  tags = {
    Name = "${var.env_prefix}-private_instance"
  }
}

resource "aws_security_group" "private_sec_group" {
  name        = "${var.env_prefix}-priv_group"
  description = "Allow ssh inbound "
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "ssh from VPC cidr range"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_prefix}-private_sec_group"
  }
}