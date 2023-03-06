prompt = "Portrait of sks person, high detail"
negative_prompt = "ugly, old"
num_samples = 2
guidance_scale = 7.5
num_inference_steps = 30
height = 512
width = 512
seed = -1

import torch
from torch import autocast
from diffusers import StableDiffusionPipeline, DDIMScheduler

model_path = "/workspace/stable_diffusion/output/800"
if 'pipe' not in locals():
    scheduler = DDIMScheduler(beta_start=0.00085, beta_end=0.012, beta_schedule="scaled_linear", clip_sample=False,
                              set_alpha_to_one=False)
    pipe = StableDiffusionPipeline.from_pretrained(model_path, scheduler=scheduler, safety_checker=None,
                                                   torch_dtype=torch.float16).to("cuda")
    g_cuda = None

g_cuda = torch.Generator(device='cuda')

g_cuda.manual_seed(seed)

with autocast("cuda"), torch.inference_mode():
    images = pipe(
        prompt,
        height=height,
        width=width,
        negative_prompt=negative_prompt,
        num_images_per_prompt=num_samples,
        num_inference_steps=num_inference_steps,
        guidance_scale=guidance_scale,
        generator=g_cuda
    ).images

    for i in range(len(images)):
        images[i].save("/workspace/stable_diffusion/output/images/" + str(i) + ".png")
