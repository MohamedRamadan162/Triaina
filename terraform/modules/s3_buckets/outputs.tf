output "s3_user_content_bucket_arn" {
  description = "Users bucket ARN"
  value       = aws_s3_bucket.user_content_bucket.arn
}

output "s3_course_content_bucket_arn" {
  description = "Courses bucket ARN"
  value       = aws_s3_bucket.course_content_bucket.arn
}
