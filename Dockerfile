FROM ubuntu:focal

# Install dependencies
RUN apt-get update && apt-get install -y gnupg2 apt-transport-https
RUN echo "deb https://apt.datadoghq.com/ stable main" > /etc/apt/sources.list.d/datadog.list
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 A2923DFF56EDA6E76E55E492D3A80E30382E94DE
RUN apt-get update && apt-get install -y datadog-agent

# Enable DBM for GCP
RUN echo "export DD_HISTOGRAM_PERCENTILES=\"0.95\"" >> /etc/datadog-agent/datadog.yaml
RUN echo "dbm_enable: true" >> /etc/datadog-agent/datadog.yaml
RUN echo "dbm_env: gcp" >> /etc/datadog-agent/datadog.yaml

# Start the Datadog agent
CMD ["datadog-agent", "start"]
