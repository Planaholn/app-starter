from fastapi import FastAPI

app = FastAPI(title="App Starter")

@app.get("/health")
def health():
    return {"status": "ok"}
