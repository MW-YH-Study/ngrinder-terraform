# EFS 생성
resource "aws_efs_file_system" "efs" {
  creation_token = var.creation_token
  encrypted      = true

  tags = {
    Name = "${var.creation_token}-efs"
  }
}
