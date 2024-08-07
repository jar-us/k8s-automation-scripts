#!/bin/bash

# Set the app name
app_name="your_app_name"

# Get the current date and time in the format YYYY-MM-DD_HH-MM-SS
current_date_time=$(date +"%Y-%m-%d_%H-%M-%S")

# Construct the file name
file_name="${app_name}-${current_date_time}.csv"

# Print header for the table and redirect to the CSV file
printf "NAMESPACE,POD_NAME,READY,CONTAINER_NAME,STATUS\n" > "$file_name"

# Get all namespaces
namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# Iterate over each namespace and print pod details
for ns in $namespaces; do
  # Get pods and extract desired information
  kubectl get pods -n "$ns" -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{range .status.containerStatuses[*]}{.ready}{"\t"}{.name}{"\t"}{end}{.status.phase}{"\n"}{end}' |
    while read -r namespace podname ready containername status; do
      # Append each row to the CSV file
      printf "%s,%s,%s,%s,%s\n" "$namespace" "$podname" "$ready" "$containername" "$status" >> "$file_name"
    done
done

echo "Output saved to $file_name"