data "aws_efs_file_system" "controller_efs" {
  file_system_id = var.efs_id
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.project_name}-efs-sg"
  description = "Security group for Ngrinder EFS mount targets"
  vpc_id      = aws_vpc.ngrinder.id

  ingress {
    description = "NFS from VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.controller.id]
  }

  tags = {
    Name = "${var.project_name}-ngrinder-efs-sg"
  }
}

# EFS 마운트 타겟 생성
resource "aws_efs_mount_target" "efs_mt" {
  count = length(aws_subnet.ngrinder_public)

  file_system_id = data.aws_efs_file_system.controller_efs.id
  subnet_id      = aws_subnet.ngrinder_public[count.index].id
  security_groups = [aws_security_group.efs_sg.id]
}
