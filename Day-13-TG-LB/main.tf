# STEP 1: Define the Target Group
# This tells the Load Balancer where to send the traffic (e.g., port 80)
resource "aws_lb_target_group" "my_tg" {
  name     = "my-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id # Reference to your VPC ID

  # Health Check ensures the ALB only sends traffic to working servers
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# STEP 2: Define the Application Load Balancer
# This creates the physical ALB in your public subnets
resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false # false means it is internet-facing
  load_balancer_type = "application"
  
  # Security Groups and Subnets (ALB requires at least 2 subnets in different AZs)
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  tags = {
    Name = "Main-ALB"
  }
}

# STEP 3: Define the Listener
# This connects the ALB to the Target Group so it knows where to route requests
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "80"
  protocol          = "HTTP"

  # Default action: Forward all incoming traffic to the Target Group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}