
servers = [
  {
    name = "server1",
    ami = "ami-08fea9e08576c443b",
    instance_type = "t2.micro",
    subnet_id = "",
    associate_public_ip_address = true,
    key_name = "TeamA-bastion-key-pair-public"
    vpc_security_group_ids = [],
  },
  {
    name = "server2",
    ami = "ami-08fea9e08576c443b",
    instance_type = "t2.micro",
    subnet_id = "",
    associate_public_ip_address = true,
    key_name = "TeamA-bastion-key-pair-public"
    vpc_security_group_ids = [],
  },
  {
    name = "server3",
    ami = "ami-08fea9e08576c443b",
    instance_type = "t2.micro",
    subnet_id = "",
    associate_public_ip_address = true,
    key_name = "TeamA-bastion-key-pair-public"
    vpc_security_group_ids = [],
  }
]


servers-privateEc2 = [
  {
    name = "server1-privateEc2",
    ami = "ami-08fea9e08576c443b",
    instance_type = "t2.micro",
    subnet_id = "",
    associate_public_ip_address = false,
    key_name = "TeamA-privateEc2-key-pair-public"
    vpc_security_group_ids = [],
  },
  {
    name = "server2-privateEc2",
    ami = "ami-08fea9e08576c443b",
    instance_type = "t2.micro",
    subnet_id = "",
    associate_public_ip_address = false,
    key_name = "TeamA-privateEc2-key-pair-public"
    vpc_security_group_ids = [],
  },
  {
    name = "server3-privateEc2",
    ami = "ami-08fea9e08576c443b",
    instance_type = "t2.micro",
    subnet_id = "",
    associate_public_ip_address = false,
    key_name = "TeamA-privateEc2-key-pair-public"
    vpc_security_group_ids = [],
  }
]