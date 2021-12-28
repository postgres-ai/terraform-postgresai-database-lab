resource "aws_iam_role" "db_lab_engine_role" {
  count = "${var.source_type == "s3" ? 1 : 0}"
  name_prefix = "database_lab_engine_"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "pg_dump_access"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:ListBucket"]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::${var.source_pgdump_s3_bucket}"
        },
        {
          Action   = ["s3:GetObject","s3:GetObjectAcl"]
          Effect   = "Allow"
          Resource = "arn:aws:s3:::${var.source_pgdump_s3_bucket}/*" # Grant read access to entire bucket
        }
      ]
    })
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = "${var.source_type == "s3" ? 1 : 0}"
  name_prefix = "dle_instance_profile_"
  role = "${aws_iam_role.db_lab_engine_role[0].name}"
}
