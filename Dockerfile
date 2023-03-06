FROM puzlcloud/pytorch:1.10.1-cuda11.3-cudnn8-jupyter-g1-1.1.0-python3.8
MAINTAINER johyun@carat.im

RUN mkdir /tmp/stable_diffusion
RUN mkdir /tmp/stable_diffusion/data
RUN mkdir /tmp/stable_diffusion/data/class
RUN mkdir /tmp/stable_diffusion/data/instance
RUN mkdir /tmp/stable_diffusion/output
RUN mkdir /tmp/stable_diffusion/output/images
RUN mkdir /tmp/stable_diffusion/.huggingface
RUN echo "" >> /tmp/stable_diffusion/.huggingface/token
COPY concepts_list.json /tmp/stable_diffusion/concepts_list.json

WORKDIR /tmp
RUN wget -q https://github.com/ShivamShrirao/diffusers/raw/main/examples/dreambooth/train_dreambooth.py
RUN wget -q https://github.com/ShivamShrirao/diffusers/raw/main/scripts/convert_diffusers_to_original_stable_diffusion.py
RUN pip install -qq git+https://github.com/ShivamShrirao/diffusers
RUN pip install -q -U --pre triton
RUN sudo pip install -q accelerate transformers ftfy bitsandbytes==0.35.0 gradio natsort safetensors xformers
COPY prompt_to_text.py /tmp/stable_diffusion/prompt_to_text.py

RUN pip install runpod
ADD whatever.py /tmp/whatever.py
ADD test_input.json /tmp/test_input.json

#CMD ["python", "-u", "/tmp/whatever.py"]
CMD ["/bin/bash"]

