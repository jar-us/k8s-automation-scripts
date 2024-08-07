#!/bin/bash

# Get all namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Print header for the table
printf "%-20s %-40s %-10s %-40s %-10s\n" "NAMESPACE" "POD NAME" "READY" "CONTAINER NAME" "STATUS"
echo "---------------------------------------------------------------------------------------------------------"

# Iterate over each namespace and print pod details
for ns in $namespaces; do
    # Get pods and extract desired information
    kubectl get pods -n "$ns" -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{range .status.containerStatuses[*]}{.ready}{"\t"}{.name}{"\t"}{end}{.status.phase}{"\n"}{end}' |
        while read -r namespace podname ready containername status; do
            printf "%-20s %-40s %-10s %-40s %-10s\n" "$namespace" "$podname" "$ready" "$containername" "$status"
        done
done
