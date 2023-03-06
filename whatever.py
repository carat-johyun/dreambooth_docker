import runpod
import subprocess
import boto3
import datetime


def push_ckpt():
    s3 = boto3.client("s3")

    date = datetime.datetime.today().strftime('%Y%m%d%H%M%S')

    s3.upload_file(
        Filename="/home/ubuntu/output/8/sks.ckpt",
        Bucket="carat-assets",
        Key="dreambooth/sks_" + date + ".ckpt",
    )


def is_even(job):
    job_input = job["input"]
    data_urls = job_input["data_urls"]
    the_number = job_input["number"]

    if not isinstance(the_number, int):
        return {"error": "Silly human, you need to pass an integer."}

    for data_url in data_urls:
        subprocess.run(["wget", "-P", "/tmp/stable_diffusion/data/instance", data_url])
        print(data_url)

    subprocess.run(["sh", "/home/ubuntu/train.sh"])
    subprocess.run(["sh", "/home/ubuntu/to_ckpt.sh"])

    push_ckpt()

    if the_number % 2 == 0:
        return True

    return False


runpod.serverless.start({"handler": is_even})
