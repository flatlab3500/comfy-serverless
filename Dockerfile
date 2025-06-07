FROM runpod/pytorch:2.0.1-py3.10-cuda11.8

WORKDIR /workspace

RUN apt update && apt install -y git curl
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /workspace/ComfyUI

# Install Python packages
RUN pip install -r requirements.txt
RUN pip install fastapi uvicorn

# Download your model
RUN mkdir -p /workspace/ComfyUI/models/checkpoints && \
    curl -L -o /workspace/ComfyUI/models/checkpoints/your_model.safetensors \
      "https://civitai.com/api/download/models/128713?type=Model&format=SafeTensor&size=pruned&fp=fp16"

# Copy app code and workflow
COPY main.py /workspace/ComfyUI/main.py
COPY workflows /workspace/workflows

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
