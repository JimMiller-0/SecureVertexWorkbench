# this script is used for the installation of the VM agent for OS patching & logging agent
sudo apt-get update

  echo "Current user: `id`" >> /tmp/notebook_config.log 2>&1
  echo "Changing dir to /home/jupyter" >> /tmp/notebook_config.log 2>&1
  cd /home/jupyter
  echo "Cloning generative-ai from github" >> /tmp/notebook_config.log 2>&1
  su - jupyter -c "git clone https://github.com/GoogleCloudPlatform/generative-ai.git" >> /tmp/notebook_config.log 2>&1
  echo "Current user: `id`" >> /tmp/notebook_config.log 2>&1
  echo "Installing python packages" >> /tmp/notebook_config.log 2&1
  su - jupyter -c "pip install --upgrade --no-warn-conflicts --no-warn-script-location --user \
      google-cloud-bigquery \
      google-cloud-pipeline-components \
      google-cloud-aiplatform \
      seaborn \
      kfp" >> /tmp/notebook_config.log 2>&1