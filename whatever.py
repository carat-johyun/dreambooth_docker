import runpod
import subprocess
import boto3
import datetime


def push_ckpt():
    s3 = boto3.client("s3",
                      aws_access_key_id="AKIASELGVJXOKTZDSMP2",
                      aws_secret_access_key="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",
                      )

    date = datetime.datetime.today().strftime('%Y%m%d%H%M%S')

    s3.upload_file(
        Filename="/home/ubuntu/output/80/asim.ckpt",
        Bucket="carat-assets",
        Key="dreambooth/asim_" + date + ".ckpt",
    )

    s3.upload_file(
        Filename="/home/ubuntu/output/80/samples/0.png",
        Bucket="carat-assets",
        Key="dreambooth/samples/" + date + "_0.png",
    )
    s3.upload_file(
        Filename="/home/ubuntu/output/80/samples/1.png",
        Bucket="carat-assets",
        Key="dreambooth/samples/" + date + "_1.png",
    )
    s3.upload_file(
        Filename="/home/ubuntu/output/80/samples/2.png",
        Bucket="carat-assets",
        Key="dreambooth/samples/" + date + "_2.png",
    )
    s3.upload_file(
        Filename="/home/ubuntu/output/80/samples/3.png",
        Bucket="carat-assets",
        Key="dreambooth/samples/" + date + "_3.png",
    )


def is_even(job):
    job_input = job["input"]
    data_urls = job_input["data_urls"]
    the_number = job_input["number"]

    if not isinstance(the_number, int):
        return {"error": "Silly human, you need to pass an integer."}

    for idx in range(len(data_urls)):
        subprocess.run(
            ["wget", "-O", "/tmp/stable_diffusion/data/instance/asim (" + str(idx) + ").jpg", data_urls[idx]])

    subprocess.run(["sh", "/home/ubuntu/train.sh"])
    subprocess.run(["sh", "/home/ubuntu/to_ckpt.sh"])

    push_ckpt()

    if the_number % 2 == 0:
        return True

    return False


runpod.serverless.start({"handler": is_even})
