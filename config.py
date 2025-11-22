import os
from dotenv import load_dotenv

load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '.env'))

GOOGLE_APPLICATION_CREDENTIALS = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
GCP_PROJECT_ID = os.getenv("GCP_PROJECT", "your-gcp-project-id")
BQ_DATASET = os.getenv("BQ_DATASET", "your_bq_dataset")
BUCKET_NAME = os.getenv("GCS_BUCKET", "your-gcs-bucket-name")

print(os.getenv("GOOGLE_APPLICATION_CREDENTIALS"))