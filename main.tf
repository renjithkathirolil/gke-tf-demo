provider "aws" {
  access_key = "AKIA4EALQT3P36LMRS4L"
  secret_key = "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"
  region     = "us-east-1"
}
resource "aws_ecs_cluster" "foo" {
  name = "white-hart"
}
resource "aws_ecs_service" "mongo" {
  name            = "mongodb"
  cluster         = "${aws_ecs_cluster.foo.id}"
  task_definition = "${aws_ecs_task_definition.mongo.arn}"
  desired_count   = 3
  
  depends_on      = ["aws_iam_role_policy.foo"]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
