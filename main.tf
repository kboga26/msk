
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["MMVPC"]
  }
}

resource "aws_msk_cluster" "kafka" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type   = var.instance_type
    ebs_volume_size = var.ebs_volume_size

       client_subnets = [
      "${var.subnet_ids.subnet1}",
      "${var.subnet_ids.subnet2}",
      "${var.subnet_ids.subnet3}"
    ]
    security_groups = ["${aws_security_group.kafka-sg.id}"]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn
    encryption_in_transit {
      client_broker = var.encryption_in_transit_client_broker
      in_cluster    = var.encryption_in_transit_in_cluster
    }
  }
}

resource "aws_security_group" "kafka-sg" {
  name        = "kafka_test_sg"
  description = "SG for test kafka cluster"
  #vpc_id      = "${var.vpc_id}"
  vpc_id = data.aws_vpc.selected.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "zookeeper_connect_string" {
  value = aws_msk_cluster.kafka.zookeeper_connect_string
}
