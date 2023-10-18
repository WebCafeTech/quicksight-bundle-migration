import boto3
import time
import urllib.request

def bundle_quicksight_resources(account_id, region, resourcearns, export_format):
    quicksight_client = boto3.client('quicksight', region_name=region)

    response = quicksight_client.start_asset_bundle_export_job(
        AwsAccountId=account_id,
        AssetBundleExportJobId='quicksight-bundle-job',
        ResourceArns=resourcearns,
        ExportFormat=export_format,
        IncludeAllDependencies=True
    )

 # Retrieve the export job ID
    job_id = response['AssetBundleExportJobId']
    print(f"Export job started with JobId: {job_id}")

   # Wait for the export job to complete
    while True:
        response = quicksight_client.describe_asset_bundle_export_job(
            AwsAccountId=account_id,
            AssetBundleExportJobId=job_id
        )
        status = response['JobStatus']
        print(f"Export job status: {status}")
        if status in ['SUCCESSFUL', 'FAILED']:
            break
        time.sleep(3)

    if status == 'SUCCESSFUL':
        # Retrieve the download URL for the asset bundle
        download_url = response['DownloadUrl']
        # print(f"Asset bundle ready for download: {download_url}")

        # Download the asset bundle
        bundle_filename = 'quicksight_bundle.zip'
        urllib.request.urlretrieve(download_url, bundle_filename)
        print(f"Asset bundle downloaded: {bundle_filename}")
    elif status == 'FAILED':
        error_info = response['Errors'][0]
        print(f"Error: {error_info['Message']}")
    else:
        print(f"Asset bundle creation failed. Status: {status}")

# Get user input for account_id, region, and resourcearns
account_id = input("Enter your AWS account ID: ")
region = input("Enter the desired AWS region: ")
resourcearns = input("Enter the Quicksight resource ARNs (separated by commas): ").split(",")
export_format = input("Enter the export format (json/cf): ").lower()

# Clean up leading/trailing spaces from the input
account_id = account_id.strip()
region = region.strip()
resourcearns = [arn.strip() for arn in resourcearns]

# Set the export format based on user input
if export_format == 'json':
    export_format = 'QUICKSIGHT_JSON'
elif export_format == 'cf':
    export_format = 'CLOUDFORMATION_JSON'
else:
    print("Invalid export format specified. Exiting.")
    exit(1)

bundle_quicksight_resources(account_id, region, resourcearns, export_format)
