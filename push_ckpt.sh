import boto3
import datetime

# Create an S3 access object
s3 = boto3.client("s3")

date = datetime.datetime.today().strftime('%Y%m%d%H%M%S')

s3.upload_file(
    # Filename="/home/ubuntu/output/8/sks.ckpt",
    Filename="temp.txt",
    Bucket="carat-assets",
    Key="dreambooth/sks_" + date + ".ckpt",
)
