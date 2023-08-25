#!/bin/bash

# Function to bundle QuickSight resources
start_export_quicksight_bundle() {
    # Prompt for AWS account details
    read -p "Enter the AWS account ID of the current account: " AWS_ACCOUNT_ID
    # Prompt for region
    read -p "Enter the AWS region: " AWS_REGION
    # Prompt for region
    read -p "Enter the Dashboard ID: " DASHBOARD_ID
    # 8961e127-04fe-4848-98dc-e9c1a8c8b2d7

    echo "Bundling QuickSight resources..."

    # Update the AWS configuration file
    aws configure set region $AWS_REGION

    # Create a directory to store the bundled resources
    mkdir -p quicksight_bundle

    # Start the asset bundle export job
    export_job_response=$(aws quicksight start-asset-bundle-export-job \
        --aws-account-id "$AWS_ACCOUNT_ID" \
        --asset-bundle-export-job-id "export-job" \
        --resource-arns arn:aws:quicksight:$AWS_REGION:$AWS_ACCOUNT_ID:dashboard/$DASHBOARD_ID \
        --include-all-dependencies \
        --export-format QUICKSIGHT_JSON
    )

    # Extract the job ID from the response
    # echo $export_job_response
    job_id=$(echo $export_job_response | jq -r '.AssetBundleExportJobId')

    # # Check the status of the import job
    status=""
    while [ "$status" != "SUCCESSFUL" ] && [ "$status" != "FAILED" ]; do
        job_status_response=$(aws quicksight describe-asset-bundle-export-job \
            --aws-account-id $AWS_ACCOUNT_ID \
            --asset-bundle-export-job-id $job_id)
    
        status=$(echo $job_status_response | jq -r '.JobStatus')
        echo $status

        if ([ "$status" != "SUCCESSFUL" ] || [ "$status" != "FAILED" ]); then
            echo "Export job is still in progress. Waiting..."
            sleep 10
        fi
    done

    # Check if the import job succeeded or failed
    if [ "$status" == "SUCCESSFUL" ]; then
        # Download the file
        wget -O "quicksight-bundle.zip" "$(echo $job_status_response | jq -r '.DownloadUrl')"

        echo "Asset bundle export job completed successfully."
        echo "Download URL: $(echo $job_status_response | jq -r '.DownloadUrl')"
    else
        echo $job_status_response
        echo "Asset bundle export job failed."
    fi

    echo " "
    echo "QuickSight resources bundled successfully."
}


bundle_quicksight_resources() {
    echo "Bundling QuickSight resources..."

    # Create a directory to store the bundled resources
    mkdir -p quicksight_bundle

    # Iterate over each data source ID
    for data_source_id in $(aws quicksight list-data-sources \
        --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
        --output json \
        --query 'DataSources[].DataSourceId' \
        --output text); do
            aws quicksight describe-data-source \
                --aws-account-id "$AWS_ACCOUNT_ID"  --region "$AWS_REGION" \
                --data-source-id "$data_source_id" \
                --output json > "quicksight_bundle/data_source_$data_source_id.json"
    done

    # Export QuickSight datasets
    for dataset_id in $(aws quicksight list-data-sets \
        --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
        --output json \
        --query 'DataSetSummaries[*].DataSetId' \
        --output text); do 
            aws quicksight describe-data-set \
                --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
                --data-set-id $dataset_id \
                --output json > "quicksight_bundle/dataset_$dataset_id.json"; 
    done

    # Export QuickSight analyses
    for analysis_id in $(aws quicksight list-analyses \
        --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
        --output json --query 'AnalysisSummaryList[*].AnalysisId' \
        --output text); do 
            aws quicksight describe-analysis \
                --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
                --analysis-id $analysis_id \
                --output json > "quicksight_bundle/analysis_$analysis_id.json"; 
    done

    # Export QuickSight dashboards
    for dashboard_id in $(aws quicksight list-dashboards \
        --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
        --output json \
        --query 'DashboardSummaryList[*].DashboardId' \
        --output text); do 
            aws quicksight describe-dashboard \
                --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
                --dashboard-id $dashboard_id \
                --output json > "quicksight_bundle/dashboard_$dashboard_id.json"; 
    done

    echo "QuickSight resources bundled successfully."
}

# Main menu function
main_menu() {
    clear
    echo "***** QuickSight Resource Management *****"
    echo "1. Bundle QuickSight Dashboard including All Dependencies"
    echo "2. Exit"

    read -p "Enter your choice: " choice
    case $choice in
        1)
            start_export_quicksight_bundle
            # bundle_quicksight_resources
            ;;
        2)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac

    echo
    read -p "Press Enter to continue..."
    main_menu
}



# Start the script
main_menu
