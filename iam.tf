resource "aws_iam_role" "CloudWatchAgentRole" {
  name = "CloudWatch_Agent_Role"
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
}

resource "aws_iam_role_policy_attachment" "cloudwatch-role-policy-attach" {
  role       = "${aws_iam_role.CloudWatchAgentRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2-cloudwatch-instance-profile" {
  name = "ec2-cloudwatch-instance-profile"
  role = aws_iam_role.CloudWatchAgentRole.name
}
