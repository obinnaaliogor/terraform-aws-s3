resource "aws_kms_key" "backendkey" {
  description             = "KMS key for backend bucket"
  deletion_window_in_days = 10
}