FROM johyun/gpu_base:0.1
MAINTAINER johyun@carat.im

RUN sudo pip uninstall torchvision -y
RUN sudo pip install torchvision

RUN mkdir /tmp/stable_diffusion/data/class_style
RUN mkdir /tmp/stable_diffusion/data/instance_style

COPY train_dreambooth.py /home/ubuntu/train_dreambooth.py
COPY whatever.py /home/ubuntu/whatever.py
COPY test_input.json /home/ubuntu/test_input.json
COPY concepts_list.json /home/ubuntu/concepts_list.json
COPY prompt_to_text.py /home/ubuntu/prompt_to_text.py
COPY train.sh /home/ubuntu/train.sh
COPY to_ckpt.sh /home/ubuntu/to_ckpt.sh
COPY /bibi/* /tmp/stable_diffusion/data/class_style/

CMD ["python", "-u", "/home/ubuntu/whatever.py"]

