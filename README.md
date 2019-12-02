https://ap-northeast-1.console.aws.amazon.com/cloudformation/home?region=ap-northeast-1#/stacks/create/review?templateURL=https://pmj-bucket-prd.s3-ap-northeast-1.amazonaws.com/templates/opswitch_access_role_04_0.yml&stackName=opswitch-4-0&param_ExternalId=1ef4394f-967d-49e7-add6-670c2d570b6c&param_opswitchAccountId=444411381513

AWSTemplateFormatVersion: "2010-09-09"
Description: Create IAM-Role for opswitch
Parameters:
  ExternalId:
    Type: String
    Description: opswitch External ID
  opswitchAccountId:
    Type: String
    Description: opswitch AWSAccount ID
Resources:
  IAMRole:
    Type: "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          -
            Effect: "Allow"
            Principal:
              AWS: !Sub "arn:aws:iam::${opswitchAccountId}:root"
            Action:
              - "sts:AssumeRole"
            Condition:
              StringEquals:
                sts:ExternalId:
                  - Ref: "ExternalId"
      ManagedPolicyArns:
        - Ref: AllowActionPolicy
        - Ref: DenyActionPolicy
      Path: "/"
  AllowActionPolicy:
    Type: "AWS::IAM::ManagedPolicy"
    Properties:
      Path: "/"
      PolicyDocument:
            Version: "2012-10-17"
            Statement:
              -
                Effect: "Allow"
                Resource: "*"
                Action:
                  - "ec2:Describe*"
                  - "ec2:CreateSnapshot"
                  - "ec2:DeleteSnapshot"
                  - "ec2:CreateImage"
                  - "ec2:DeregisterImage"
                  - "ec2:CreateTags"
                  - "ec2:StartInstances"
                  - "ec2:StopInstances"
                  - "ec2:ModifyInstanceAttribute"
                  - "ec2:CopySnapshot"
                  - "ec2:CopyImage"
                  - "cloudformation:Describe*"
                  - "cloudformation:Get*"
                  - "cloudformation:CreateStackSet"
                  - "cloudformation:CreateChangeSet"
                  - "rds:Describe*"
                  - "rds:CreateDBSnapshot"
                  - "rds:DeleteDBInstance"
                  - "rds:DeleteDBSnapshot"
                  - "rds:RestoreDBInstanceFromDBSnapshot"
                  - "rds:ListTagsForResource"
                  - "rds:AddTagsToResource"
                  - "rds:StartDBInstance"
                  - "rds:StopDBInstance"
                  - "rds:CreateDBClusterSnapshot"
                  - "rds:DeleteDBClusterSnapshot"
                  - "rds:StartDBCluster"
                  - "rds:StopDBCluster"
                  - "rds:CopyDBSnapshot"
                  - "rds:CopyDBClusterSnapshot"
  DenyActionPolicy:
    Type: "AWS::IAM::ManagedPolicy"
    Properties:
      Path: "/"
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          -
            Effect: "Deny"
            Resource: "*"
            Action:
              - "s3:GetObject"
              - "acm-pca:Get*"
              - "codecommit:BatchGet*"
              - "codecommit:Describe*"
              - "codecommit:Get*"
              - "codecommit:GitPull"
              - "codecommit:List*"
              - "ds:VerifyTrust"
              - "dynamodb:BatchGetItem"
              - "dynamodb:GetItem"
              - "dynamodb:GetRecords"
              - "dynamodb:Query"
              - "dynamodb:Scan"
              - "ses:VerifyDomainDkim"
              - "ses:VerifyDomainIdentity"
              - "ses:VerifyEmailAddress"
              - "ses:VerifyEmailIdentity"
Outputs:
  AccountID:
    Value:
      Ref: AWS::AccountId
  IAMRoleName:
    Value:
      Ref: IAMRole