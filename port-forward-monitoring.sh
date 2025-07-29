#!/bin/bash

# Script: port-forward-monitoring.sh
# Description: Port-forwards Grafana and Prometheus from the monitoring namespace.

echo "📡 Starting port-forward for Grafana on http://localhost:3000 ..."
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80 &
GRAFANA_PID=$!

echo "📡 Starting port-forward for Prometheus on http://localhost:9090 ..."
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090 &
PROMETHEUS_PID=$!

# Function to stop port-forwarding on exit
cleanup() {
  echo " Stopping port-forwards..."
  kill $GRAFANA_PID $PROMETHEUS_PID
  exit
}

# Trap CTRL+C to stop both processes
trap cleanup INT

# Wait for both processes to end
wait
