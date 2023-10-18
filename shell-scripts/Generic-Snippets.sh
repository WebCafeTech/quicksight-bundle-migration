aws quicksight start-asset-bundle-export-job \
    --aws-account-id 988046883877 \
    --region ap-northeast-1 \
    --asset-bundle-export-job-id export-job-1 \
    --resource-arns arn:aws:quicksight:ap-northeast-1:988046883877:dashboard/8961e127-04fe-4848-98dc-e9c1a8c8b2d7 \
    --include-all-dependencies \
    --export-format QUICKSIGHT_JSON

aws quicksight describe-asset-bundle-export-job \
    --aws-account-id 988046883877 \
    --asset-bundle-export-job-id export-job-1


aws quicksight start-asset-bundle-export-job \
    --aws-account-id <AWS_ACCOUNT_ID> \
    --region <QUICKSIGHT_REGION> \
    --asset-bundle-export-job-id <EXPORT_JOB_ID> \
    --resource-arns <QUICKSIGHT_RESOURCE_ARN> \
    --include-all-dependencies \
    --export-format QUICKSIGHT_JSON


aws quicksight describe-asset-bundle-export-job \
    --aws-account-id <AWS_ACCOUNT_ID> \
    --asset-bundle-export-job-id <EXPORT-JOB-ID>



        status=$(echo $job_status_response | jq -r '.JobStatus')
        echo $status

        if ([ "$status" != "SUCCESSFUL" ] || [ "$status" != "FAILED" ]); then
            echo "Export job is still in progress. Waiting..."
            sleep 10
        fi
    done

   

    # data source ID
aws quicksight list-data-sources \
    --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
    --output json \
    --query 'DataSources[].DataSourceId' \
    --output text

aws quicksight describe-data-source \
    --aws-account-id "$AWS_ACCOUNT_ID"  --region "$AWS_REGION" \
    --data-source-id "$data_source_id" \
    --output json > "quicksight_bundle/data_source_$data_source_id.json"



    # QuickSight datasets
aws quicksight list-data-sets \
    --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
    --output json \
    --query 'DataSetSummaries[*].DataSetId' \
    --output text
        
aws quicksight describe-data-set \
    --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
    --data-set-id $dataset_id \
    --output json > "quicksight_bundle/dataset_$dataset_id.json"; 



    # QuickSight analyses
aws quicksight list-analyses \
    --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
    --output json --query 'AnalysisSummaryList[*].AnalysisId' \
    --output text
        
aws quicksight describe-analysis \
    --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
    --analysis-id $analysis_id \
    --output json > "quicksight_bundle/analysis_$analysis_id.json"; 



    # QuickSight dashboards
aws quicksight list-dashboards \
    --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
    --output json \
    --query 'DashboardSummaryList[*].DashboardId' \
    --output text

    
aws quicksight describe-dashboard \
    --aws-account-id "$AWS_ACCOUNT_ID" --region "$AWS_REGION" \
    --dashboard-id $dashboard_id \
    --output json > "quicksight_bundle/dashboard_$dashboard_id.json"