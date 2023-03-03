FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-runtime
MAINTAINER johyun@carat.im

RUN mkdir /workspace/apps
RUN mkdir /workspace/stable_diffusion
RUN mkdir /workspace/stable_diffusion/data
RUN mkdir /workspace/stable_diffusion/data/class
RUN mkdir /workspace/stable_diffusion/data/instance
RUN mkdir /workspace/stable_diffusion/output
RUN mkdir /workspace/stable_diffusion/output/images
RUN mkdir /workspace/stable_diffusion/.huggingface
RUN echo "" >> /workspace/stable_diffusion/.huggingface/token
COPY concepts_list.json /workspace/stable_diffusion/concepts_list.json

WORKDIR /workspace/apps
RUN apt-get update
RUN apt-get install wget -y
RUN wget https://www.python.org/ftp/python/3.8.16/Python-3.8.16.tgz
RUN tar -xvzf Python-3.8.16.tgz
RUN rm Python-3.8.16.tgz

WORKDIR /workspace/apps/Python-3.8.16
RUN apt-get install gcc -y
RUN ./configure
RUN apt-get install make
RUN make altinstall
RUN rm /opt/conda/bin/python3
RUN ln -s /workspace/apps/Python-3.8.16/python /opt/conda/bin/python3

WORKDIR /workspace
RUN wget -q https://github.com/ShivamShrirao/diffusers/raw/main/examples/dreambooth/train_dreambooth.py
RUN wget -q https://github.com/ShivamShrirao/diffusers/raw/main/scripts/convert_diffusers_to_original_stable_diffusion.py
RUN apt-get install git -y
RUN pip3 install -qq git+https://github.com/ShivamShrirao/diffusers
RUN pip3 install -q -U --pre triton
RUN pip3 install -q accelerate transformers ftfy bitsandbytes==0.35.0 gradio natsort safetensors xformers
COPY prompt_to_text.py /workspace/stable_diffusion/prompt_to_text.py

RUN pip3 install runpod
ADD whatever.py /workspace/whatever.py
ADD test_input.json /workspace/test_input.json

#CMD ["python", "-u", "/workspace/whatever.py"]
CMD ["/bin/bash"]

