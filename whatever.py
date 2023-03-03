import runpod
import subprocess


def is_even(job):
    job_input = job["input"]
    data_urls = job_input["data_urls"]
    the_number = job_input["number"]

    if not isinstance(the_number, int):
        return {"error": "Silly human, you need to pass an integer."}

    subprocess.run(["ls", "-l"])

    for data_url in data_urls:
        subprocess.run(["wget", "-P", "/workspace/stable_diffusion/data/instance", data_url])
        print(data_url)

    if the_number % 2 == 0:
        return True

    return False


runpod.serverless.start({"handler": is_even})
