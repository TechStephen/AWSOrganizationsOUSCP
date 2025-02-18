# Create Organization
resource "aws_organizations_organization" "my_org" {
  feature_set = "ALL"
}

# Create Organizational Units (Dev, Finance, HR, etc.)
resource "aws_organizations_organizational_unit" "development_ou" {
  name       = "Development"
  parent_id  = aws_organizations_organization.my_org.roots[0].id

  tags = {
    Name = "Development"
  }
}

resource "aws_organizations_organizational_unit" "finance_ou" {
  name       = "Finance"
  parent_id  = aws_organizations_organization.my_org.roots[0].id

  tags = {
    Name = "Finance"
  }
}

resource "aws_organizations_organizational_unit" "hr_ou" {
  name       = "HR"
  parent_id  = aws_organizations_organization.my_org.roots[0].id

  tags = {
    Name = "HR"
  }
}

# Create Accounts
resource "aws_organizations_account" "dev_account_bob" {
  name  = "Bob Johnson"
  email = "bobjohnson@gmail.com"
  parent_id = aws_organizations_organizational_unit.development_ou.id

  tags = {
    Name = "Bob Johnson"
  }
}

resource "aws_organizations_account" "finance_acc_jack" {
  name  = "Joe Jackson"
  email = "joejackson@gmail.com"
  parent_id = aws_organizations_organizational_unit.finance_ou.id

  tags = {
    Name = "Joe Jackson"
  }
}

resource "aws_organizations_account" "hr_acc_sally" {
  name  = "Sally Smith"
  email = "sallysmith@gmail.com"
  parent_id = aws_organizations_organizational_unit.hr_ou.id

  tags = {
    Name = "Sally Smith"
  }
}

# Create SCP (Service Control Policy)
resource "aws_organizations_policy" "main_scp" {
  name        = "Development SCP"
  description = "Development SCP"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Deny",
        "Action" : "*",
        "Resource" : "*",
        "Condition" : {
          "StringNotEqualsIfExists" : {
            "aws:PrincipalOrgID" : "o-1234567890abcdef"
          }
        }
      }
    ]
  })
}

# Put SCP in Ous
resource "aws_organizations_policy_attachment" "development_scp_attachment" {
  policy_id = aws_organizations_policy.main_scp.id
  target_id = aws_organizations_organizational_unit.development_ou.id
}