resource "aws_s3_bucket" "user_content_bucket" {
  bucket = "triaina-content"
  tags = {
    Name = "Users data bucket"
  }
}
