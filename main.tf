provider "aws" {
  region = "us-east-1"
}

# S3 Bucket
resource "aws_s3_bucket" "nextjs_bucket" {
  bucket = "nextjs-portfolio-bucket-uzeirr"
}

# ownership control; this allows us to have complete ownership of the bucket and the objects; no one can change the objects
resource "aws_s3_bucket_ownership_controls" "nextjs_bucket_ownership_controls" {
  bucket = aws_s3_bucket.nextjs_bucket.id

  rule {
    object_ownership = "BucketOwnerPrefferred" # the bucket owner owns all the object 
  }
}

# Block Public Access # provides a centeralized place to control public access
resource "aws_s3_bucket_public_access_block" "nextjs_bucket_public_aceess_block" {
    bucket = aws_s3_bucket.nextjs_bucket.id

    block_public_acls = false # setting to false allows for public access 
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false

}

# Bucket ACL # 
resource "aws_s3_bucket_acl" "nextjs_bucket_acl" {
  depends_on = [ 
    aws_s3_bucket_ownership_controls.nextjs,
    aws_s3_bucket_public_access_block.nextjs_bucket_public_access_block
   ]
   bucket = aws_s3_bucket.nextjs_bucket.id
   acl = "public-read" # sets the acl to public read 
}

# bucket policy  # allows public access to everything in our bucket; uses IAM policies 
resource "aws_s3_bucket_policy" "nextjs_bucket_policy" {
  bucket = aws_s3_bucket.next_bucket.id

  policy = jsondecode(({
    version = "2012-10-17"
    Statement = [
        {
            Sid = "PublicReadGetObject"
            Effect = "Allow"
            Principle = "*"
            Action = "s3:GetObject"
            Resource = "${aws_s3_bucket.nextjs_bucket.arn}/*" # specifices the object and what is inside it



        }
    ]
  }


    )  )
}