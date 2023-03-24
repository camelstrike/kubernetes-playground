#!/bin/bash

set -u

COREOS_MON_CRDS_VERSION="v0.63.0"
GRAFANA_MON_CRDS_VERSION="v0.32.1"

COREOS_MON_CRDS_URL="https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$COREOS_MON_CRDS_VERSION/example/prometheus-operator-crd"
GRAFANA_MON_CRDS_URL="https://raw.githubusercontent.com/grafana/agent/$GRAFANA_MON_CRDS_VERSION/production/operator/crds"

COREOS_MON_CRDS=(
    monitoring.coreos.com_alertmanagerconfigs.yaml
    monitoring.coreos.com_alertmanagers.yaml
    monitoring.coreos.com_podmonitors.yaml
    monitoring.coreos.com_probes.yaml
    monitoring.coreos.com_prometheuses.yaml
    monitoring.coreos.com_prometheusrules.yaml
    monitoring.coreos.com_servicemonitors.yaml
    monitoring.coreos.com_thanosrulers.yaml
)

GRAFANA_MON_CRDS=(
    monitoring.grafana.com_grafanaagents.yaml
    monitoring.grafana.com_integrations.yaml
    monitoring.grafana.com_logsinstances.yaml
    monitoring.grafana.com_metricsinstances.yaml
    monitoring.grafana.com_podlogs.yaml
)



CHECK_COREOS_MON_CRD_EXISTS=$(kubectl get crd servicemonitors.monitoring.coreos.com > /dev/null 2>&1)
CHECK_GRAFANA_MON_CRD_EXISTS=$(kubectl get crd podlogs.monitoring.grafana.com > /dev/null 2>&1)

if [ ! "$CHECK_COREOS_MON_CRD_EXISTS" ]
then
    for crd in "${COREOS_MON_CRDS[@]}"
        do
            kubectl apply --server-side -f "$COREOS_MON_CRDS_URL/$crd"
    done
fi

if [ ! "$CHECK_GRAFANA_MON_CRD_EXISTS" ]
then
    for crd in "${GRAFANA_MON_CRDS[@]}"
        do
            kubectl apply --server-side -f "$GRAFANA_MON_CRDS_URL/$crd"
    done
fi
