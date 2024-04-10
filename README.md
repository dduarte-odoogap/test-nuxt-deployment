# Nuxt 3 Redis Test on GCR

```bash
$> gcloud redis instances describe my-redis-cache  --region=europe-west3 --format='value(host)'
$> gcloud auth configure-docker
$> docker build --build-arg="REDIS_URL=redis://10.99.152.92:6379" . -t gcr.io/my-nuxt-redis-test-app/simple-nuxt-redis:1.1
$> docker image push gcr.io/my-nuxt-redis-test-app/simple-nuxt-redis:1.1
$> gcloud services enable containerregistry.googleapis.com --project=my-nuxt-redis-test-app
$> terraform init
$> terraform plan
$> terraform apply

```
