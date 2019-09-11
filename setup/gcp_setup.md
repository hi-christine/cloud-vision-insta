## Create Service Account
```
gcloud iam service-accounts create vision-api-user "--display-name=Vision API User" --project=cloud-vision-api-246317
gcloud iam service-accounts keys create ~/vision-api-user-key.json --iam-account=vision-api-user@cloud-vision-api-246317.iam.gserviceaccount.com
gsutil iam ch serviceAccount:vision-api-user@cloud-vision-api-246317.iam.gserviceaccount.com:roles/storage.objectAdmin gs://cloud-vision-instagram
gsutil iam ch serviceAccount:vision-api-user@cloud-vision-api-246317.iam.gserviceaccount.com:roles/storage.legacyBucketReader gs://cloud-vision-instagram
gcloud services enable vision.googleapis.com --project=cloud-vision-api-246317
gcloud services enable automl.googleapis.com --project=cloud-vision-api-246317
gcloud services enable storage-component.googleapis.com --project=cloud-vision-api-246317
gcloud services enable storage-api.googleapis.com --project=cloud-vision-api-246317
```

