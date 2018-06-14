variable "region" {
  type    = "string"
  default = "us-east-1"
}

variable "account_id" {
  type    = "string"
  default = "850557506070"
}

provider "aws" {
  region  = "${var.region}"
  profile = "konwinkler"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.js"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "example_test_function" {
  filename      = "${data.archive_file.lambda.output_path}"
  function_name = "example_test_function"
  role          = "${aws_iam_role.example_api_role.arn}"
  handler       = "index.handler"

  runtime = "nodejs8.10"

  # source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  publish = true
}

resource "aws_iam_role" "example_api_role" {
  name               = "example_api_role"
  assume_role_policy = "${file("policies/lambda-role.json")}"
}
