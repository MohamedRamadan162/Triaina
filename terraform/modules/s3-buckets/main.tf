resource "aws_s3_bucket" "user-content-bucket" {
  bucket        = "user-content"
  force_destroy = false
  tags = {
    Name = "Users data bucket"
  }
}

resource "aws_s3_bucket" "course-content-bucket" {
  bucket        = "course-content"
  force_destroy = false
  tags = {
    Name = "Courses data bucket"
  }
}
