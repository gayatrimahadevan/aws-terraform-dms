resource "aws_key_pair" "acg" {
  key_name   = "acg"
  public_key = file("acg.pub")
}
