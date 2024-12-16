resource "aws_s3_bucket" "user_content_bucket" {
  bucket = "user-content"
  tags = {
    Name = "Users data bucket"
  }
}

resource "aws_s3_bucket" "course_content_bucket" {
  bucket = "course-content"
  tags = {
    Name = "Courses data bucket"
  }
}
