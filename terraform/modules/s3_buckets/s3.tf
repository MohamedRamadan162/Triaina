resource "aws_s3_bucket" "user_content_bucket" {
  bucket = "triaina-user-content"
  tags = {
    Name = "Users data bucket"
  }
}

resource "aws_s3_bucket" "course_content_bucket" {
  bucket = "triaina-course-content"
  tags = {
    Name = "Courses data bucket"
  }
}
