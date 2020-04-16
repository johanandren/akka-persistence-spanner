#!/bin/bash -x
echo "Installing latest gcloud version"
gcloud version || true
if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash > /dev/null ; fi
source /home/travis/google-cloud-sdk/path.bash.inc
gcloud version

echo "Setting up emulator"

#docker-compose version && docker-compose  -f docker/docker-compose.yml up -d
gcloud config set auth/disable_credentials true
gcloud components update --quiet
gcloud beta emulators spanner start --quiet
gcloud config configurations create emulator || true # may already exist
gcloud config set api_endpoint_overrides/spanner http://localhost:9020/
gcloud config set project akka
gcloud spanner instances create akka --config=emulator-config --description="Test Instance" --nodes=1 || true # may already exist