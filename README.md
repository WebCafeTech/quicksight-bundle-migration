# AWS Quicksight Asset Migration
This repo contains shell scripts to perform migration. Import and export of assets using the python and shell scripts.

## Objective
The aim of this repo is to download the already existing quicksight dashboard created using GUI method in JSON format and to deploy it on to different region or different account.


### Prerequisites
- AWS CLI configured with appropriate credentials
- Python or Bash shell
- jq 
- wget


### Idea
I have created script that follow the sequence of tasks to be performed in an automated fashion.

### Python code
![Python](./python/README.md)

### Bash Shell script
![Shell Script](./shell-scripts/readme.md)


### Additional Notes

- By default, the script exports the resources in QuickSight JSON format. If you want to export in CloudFormation JSON format, uncomment the line `ExportFormat='CLOUDFORMATION_JSON'` and comment out the line `ExportFormat='QUICKSIGHT_JSON'` in the script.

- The exported asset bundle file will contain the exported resources and their dependencies. You can customize the script to include additional resources as per your requirements.

- Make sure you have proper permissions and access to the QuickSight resources you want to export.

## Security
See CONTRIBUTING for more information.

## License
This library is licensed under the MIT-0 License. See the LICENSE file.
