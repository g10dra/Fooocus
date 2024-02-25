FROM nvidia/cuda:12.3.0-runtime-ubuntu22.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-pip libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libxext6 && \
    rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/pip pip3 install virtualenv
RUN mkdir /app

WORKDIR /app

RUN virtualenv /venv
RUN . /venv/bin/activate && \
    pip3 install --upgrade pip

COPY requirements_versions.txt /app/requirements_versions.txt
RUN . /venv/bin/activate && \
    pip3 install -r requirements_versions.txt

COPY . /app/

# may need to adjust the arch
RUN ln -s /usr/lib/x86_64-linux-gnu/mesa/libGL.so.1 /usr/lib/libGL.so.1
RUN ln -s /usr/lib/x86_64-linux-gnu/libgthread-2.0.so.0 /usr/lib/libgthread-2.0.so.0

ENTRYPOINT [ "bash", "-c", ". /venv/bin/activate && exec \"$@\"", "--" ]
CMD [ "python3", "launch.py", "--listen" ]
