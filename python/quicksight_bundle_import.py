import os
import boto3
import time

def import_quickSight_bundle(region, account_id, bundle_zip_path, bundle_id):
    quicksight_client = boto3.client('quicksight', region_name=region)

    # Start the asset bundle import job
    with open(bundle_zip_path, 'rb') as file:
        response = quicksight_client.start_asset_bundle_import_job(
            AwsAccountId=account_id,
            AssetBundleImportJobId=bundle_id,
            AssetBundleImportSource={
                # 'Body': 'file://{}'.format(file_list[0])  # Assuming the first file in the list is the dataset JSON
                'Body': file.read()
            },
            FailureAction='ROLLBACK',
            OverrideParameters={ 
                'ResourceIdOverrideConfiguration': {
                    'PrefixForAllResources': 'ecca'
                },
                "DataSources": [
                    {
                        "DataSourceId": '11b6de83-9d5d-4d8d-a3ff-bf8bd335bfd1',
                        'Name': 'datasource1',
                        'DataSourceParameters': {
                            'RdsParameters': {
                                "InstanceId": 'YOUR-INSTANCE-ID',
                                "Database": 'YOUR-DB-ID'
                            },
                        },
                        'Credentials': {
                            'CredentialPair': {
                                'Username': 'YOUR-USER-NAME',
                                'Password': 'YOUR-RDS-PASSWORD'
                            },
                            # 'SecretArn': 'string'
                        }
                    }
                ],
                'DataSets': [
                    {
                        'DataSetId': 'bc4f0368-3467-4c5d-873e-ef402f0966de',
                        'Name': 'dataset1'
                    },
                ],
                'Dashboards': [
                    {
                        'DashboardId': '924af88b-30f5-4ec8-88d1-01f75c71dcb2',
                        'Name': 'dashboard1'
                    },
                ]
            }
        )

    # print(f"{response}")
    job_id = response['AssetBundleImportJobId']
    print(f"Asset bundle import job started. Job ID: {job_id}")

    # Wait for the asset bundle import job to complete
    while True:
        response = quicksight_client.describe_asset_bundle_import_job(
            AwsAccountId=account_id,
            AssetBundleImportJobId=job_id
        )
        print(f"{response}")
        status = response['JobStatus']
        print(f"Job Status: {status}")

        if status == 'SUCCESSFUL':
            print("QuickSight bundle import completed successfully.")
            break
        elif status == 'FAILED':
            print("QuickSight bundle import failed.")
            print(f"{response}")
            error_message = response['AssetBundleImportJob']['Status']['Message']
            print(f"Error Message: {error_message}")
            break
        elif status == 'FAILED_ROLLBACK_COMPLETED':
            print("QuickSight bundle import failed.")
            error_info = response['Errors'][0]
            print(f"Error: {error_info['Message']}")
            break

        time.sleep(10)


# Replace 'TARGET_REGION', 'TARGET_ACCOUNT_ID', 'BUNDLE_FOLDER_PATH', and 'YOUR_BUNDLE_ID' with the appropriate values
target_region = 'eu-central-1'
target_account_id = 'YOUR-ACCOUNT-ID'
# bundle_folder_path = './quicksight_bundle_export/'
bundle_zip_path= 'scripts.zip'
bundle_id = 'QS_BUNDLE_ID'

import_quickSight_bundle(target_region, target_account_id, bundle_zip_path, bundle_id)
