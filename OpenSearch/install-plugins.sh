#!/bin/bash
set -e

PLUGINS=(
  "opensearch-knn"
  "opensearch-anomaly-detection"
  "opensearch-alerting"
  "analysis-phonetic"
  "analysis-icu"
  "mapper-murmur3"
  "opensearch-geospatial"
)

for plugin in "${PLUGINS[@]}"; do
  if ! /usr/share/opensearch/bin/opensearch-plugin list | grep -q "$plugin"; then
    echo "Installing plugin: $plugin"
    /usr/share/opensearch/bin/opensearch-plugin install --batch "$plugin"
  else
    echo "Plugin $plugin already installed"
  fi
done
