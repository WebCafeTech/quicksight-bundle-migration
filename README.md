# AWS Quicksight Asset as a bundle.
This repo contains python scripts to perform migration. Import and export of assets.

# Quicksight Bundle Export and Download

This Python script allows you to export and download resources from Amazon QuickSight, bundling them into a single asset bundle file.

## Prerequisites

- Python 3.x installed
- AWS CLI configured with appropriate credentials and region
- Boto3 library installed (`pip install boto3`)

## Usage

1. Clone the repository or copy the Python script (`quicksight_bundle_export.py`) to your local machine.

2. Install the required Python library:
```bash
pip install boto3
```

3. Open the `quicksight_bundle_export.py` file in a text editor.

4. Update the following variables in the script:

- `account_id`: Replace with your AWS account ID.
- `region`: Replace with your desired AWS region.
- `resourcearns`: Replace with the QuickSight resource ARNs you want to export, separated by commas. Example: `['arn:aws:quicksight:us-east-1:123456789012:analysis/abc123', 'arn:aws:quicksight:us-east-1:123456789012:dashboard/def456']`.

5. Save the script file.

6. Open a terminal or command prompt and navigate to the directory where the script is saved.

7. Run the script:

```bash
python quicksight_bundle_export.py
```


8. Provide the required inputs as prompted:

- Enter your AWS account ID.
- Enter the desired AWS region.
- Enter the QuickSight resource ARNs (separated by commas).

9. The script will initiate the asset bundle export job and provide status updates until the export is completed.

10. Once the export is successful, the asset bundle file (`quicksight_bundle.zip`) will be downloaded to the same directory as the script.

## Additional Notes

- By default, the script exports the resources in QuickSight JSON format. If you want to export in CloudFormation JSON format, uncomment the line `ExportFormat='CLOUDFORMATION_JSON'` and comment out the line `ExportFormat='QUICKSIGHT_JSON'` in the script.

- The exported asset bundle file will contain the exported resources and their dependencies. You can customize the script to include additional resources as per your requirements.

- Make sure you have proper permissions and access to the QuickSight resources you want to export.



