data "http" "my_ip" {
    url = "http://checkip.amazonaws.com/"
}

resource "aws_vpc" "NFS-NET" {
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "NFS-NET"
    }
}

resource "aws_subnet" "NFS-SUBNET" {
    vpc_id     = aws_vpc.NFS-NET.id
    cidr_block = "10.0.1.0/28"
    tags = {
        Name = "NFS-SUBNET"
    }
    availability_zone = "us-east-1a"
}

resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.NFS-NET.id
    tags = {
      "name" = "IG"
    }
}

resource "aws_route_table" "vpc_to_gateway" {
    vpc_id = aws_vpc.NFS-NET.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IG.id
    }

}

resource "aws_route_table_association" "NFS-subnet-association" {
    route_table_id = aws_route_table.vpc_to_gateway.id
    subnet_id      = aws_subnet.NFS-SUBNET.id
}

resource "aws_security_group" "SG" {
    name = "Allow_ssh_me"
    vpc_id = aws_vpc.NFS-NET.id

}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
    security_group_id = aws_security_group.SG.id
    from_port         = 22
    to_port           = 22
    ip_protocol          = "tcp"
    cidr_ipv4 = "${chomp(data.http.my_ip.response_body)}/32"
}
resource "aws_vpc_security_group_egress_rule" "egress" {
    security_group_id = aws_security_group.SG.id
    ip_protocol       = "-1"
    cidr_ipv4 = "0.0.0.0/0"
    #Note that if ip_protocol is set to -1, it translates to all protocols, all port ranges, and from_port and to_port values should not be defined.
}

resource "aws_vpc_security_group_ingress_rule" "Allow_ALL_traffic" {
    security_group_id = aws_security_group.SG.id
    ip_protocol       = "-1"
    cidr_ipv4       = aws_subnet.NFS-SUBNET.cidr_block
}

resource "aws_key_pair" "nfs_key" {
    public_key = file("~/.ssh/nfs_key.pub")
    key_name = "nfs_key"
}

resource "aws_instance" "NFS" {
    ami = trimspace(data.local_file.ami_id_file.content)
    instance_type = "t2.micro"
    key_name = aws_key_pair.nfs_key.key_name
    subnet_id = aws_subnet.NFS-SUBNET.id
    vpc_security_group_ids = [aws_security_group.SG.id]
    tags = {
        Name = "NFS"
    }
    associate_public_ip_address = true
}

resource "aws_instance" "NFS-Client" {
    ami = trimspace(data.local_file.ami_id_file.content)
    instance_type = "t2.micro"
    key_name = aws_key_pair.nfs_key.key_name
    subnet_id = aws_subnet.NFS-SUBNET.id
    vpc_security_group_ids = [aws_security_group.SG.id]
    tags = {
        Name = "NFS_Client"
    }

    associate_public_ip_address = true
}

data "local_file" "ami_id_file" {
    filename = "${path.module}/ami_id.txt"
}

# path.module is the filesystem path of the module where the expression is placed. We do not recommend using path.module in write operations because it can produce different behavior depending on whether you use remote or local module sources. Multiple invocations of local modules use the same source directory, overwriting the data in path.module during each call. This can lead to race conditions and unexpected results.
# path.root is the filesystem path of the root module of the configuration.
# path.cwd is the filesystem path of the original working directory from where you ran Terraform before applying any -chdir argument. This path is an absolute path that includes details about the filesystem structure. It is also useful in some advanced cases where Terraform is run from a directory other than the root module directory. We recommend using path.root or path.module over path.cwd where possible.
# terraform.workspace is the name of the currently selected workspace.
