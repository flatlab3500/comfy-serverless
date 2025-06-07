from fastapi import FastAPI
import subprocess
import uuid
import os

app = FastAPI()

@app.get("/generate")
def generate():
    job_id = str(uuid.uuid4())
    workflow_path = "/workspace/workflows/basic_txt2img.json"
    output_dir = f"/workspace/ComfyUI/output/{job_id}"
    os.makedirs(output_dir, exist_ok=True)

    command = [
        "python3", "main.py",
        "--output-directory", output_dir,
        "--workflow", workflow_path,
        "--disable-auto-launch"
    ]
    subprocess.run(command)

    for file in os.listdir(output_dir):
        if file.endswith(".png"):
            return {"output_image": f"{output_dir}/{file}"}

    return {"error": "No output found"}
