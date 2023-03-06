FROM johyun/gpu_base:0.1
MAINTAINER johyun@carat.im

COPY whatever.py /home/ubuntu/whatever.py
COPY test_input.json /home/ubuntu/test_input.json
COPY concepts_list.json /home/ubuntu/concepts_list.json
COPY prompt_to_text.py /home/ubuntu/prompt_to_text.py
COPY train.sh /home/ubuntu/train.sh
COPY to_ckpt.sh /home/ubuntu/to_ckpt.sh

#CMD ["python", "-u", "/home/ubuntu/whatever.py"]
CMD ["/bin/bash"]

