output "s3_user_content_bucket_arn" {
  value = aws_s3_bucket.user-content-bucket.arn
}

output "s3_course_content_bucket_arn" {
  value = aws_s3_bucket.course-content-bucket.arn
}

output "user-content-bucket-domain-name" {
  value       = aws_s3_bucket.user-content-bucket.bucket_regional_domain_name
  description = "The regional domain name for the Users' data S3 bucket"
}

output "course-content-bucket-domain-name" {
  value       = aws_s3_bucket.course-content-bucket.bucket_regional_domain_name
  description = "The regional domain name for the Courses' data S3 bucket"
}
