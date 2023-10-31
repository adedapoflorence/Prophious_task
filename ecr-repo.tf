provider "aws" {
  region = "us-east-2"
}

resource "aws_ecr_repository" "project_ecr_repo" {
  name = "ecr-repo"
}

resource "aws_iam_policy" "ecr_policy" {
  name = "ecr_policy"
  description = "ECR policy for pushing and pulling images"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetAuthorizationToken",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Resource": "${aws_ecr_repository.project_ecr_repo.repository_url}:*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecr.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_ecr_policy" {
  policy_arn = aws_iam_policy.ecr_policy.arn
  role       = aws_iam_role.ecr_role.name
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  name = "ecr-repo-policy"
  repository = aws_ecr_repository.project_ecr_repo.name

  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Action = "ecr:BatchCheckLayerAvailability",
        Effect = "Allow",
        Principal = "*",
        Resource = aws_ecr_repository.project_ecr_repo.arn
      },
      {
        Action = "ecr:GetDownloadUrlForLayer",
        Effect = "Allow",
        Principal = "*",
        Resource = aws_ecr_repository.project_ecr_repo.arn
      },
      {
        Action = "ecr:GetRepositoryPolicy",
        Effect = "Allow",
        Principal = "*",
        Resource = aws_ecr_repository.project_ecr_repo.arn
      },
      {
        Action = "ecr:PutImage",
        Effect = "Allow",
        Principal = "*",
        Resource = aws_ecr_repository.project_ecr_repo.arn
      }
    ]
  })
}
