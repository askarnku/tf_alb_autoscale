output "alb_dns_name" {
  description = "The DNS name of the ALB. You can use this to check the website. It should serve \"Hello, World\"."
  value       = aws_lb.ASALB.dns_name
}