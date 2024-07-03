resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "<gerado_aws>"
  ]

  tags = {
    IAC = "True"
  }
}

resource "aws_iam_role" "app-runner-role" {
  name = "app-runner-role"

  assume_role_policy = jsonencode({
    Version: "2012-10-17"
    Statement: [
      {
        Effect: "Allow"
        Principal: {
          Service: "build.apprunner.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam:aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    // colar aqui o JSON gerado ao configurar Web Identity no console da AWS
  })

  inline_policy {
    name = "ecr-app-permission"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
		      Sid = "Statement1",
		      Action = "apprunner:*",
		      Effect = "Allow",
		      Resource = "*"
	      },
	      {
		      Sid = "Statement2",
		      Action = [
            "iam:PassRole",
            "iam:CreateServiceLinkedRole"
          ],
		      Effect = "Allow",
		      Resource = "*"
	      },
        {
          Sid = "Statement3"
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:GetAuthorizationToken"
          ]
          Effect = "Allow"
          Resource = "*"
        }
      ]
    })
  }

  tags = {
    IAC = "True"
  }
}
