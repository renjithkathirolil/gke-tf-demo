provider "aws" {
  access_key = "*******************************"
  secret_key = "******************************"
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
 

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
