resource "aws_s3_bucket" "triaina_content_bucket" {
  bucket = "triaina-content"
  tags = {
    Name = "Users data bucket"
  }
}
