Test the pipeline
1. Create 5 Github Repository secrets with the needed values:
- GCP_PROJECT_ID (where SecOps instance is hosted)
- GCP_SA_KEY (with Owner rights or appropriate rights)
- GCS_BUCKET (where you tfstate is hosted)
- SECOPS_INSTANCE_ID (Instance ID of SecOps)
- SECOPS_INSTANCE_REGION (Instance Region of SecOps)

2. Create a new / Change an exisiting YARA-L rules under folder rules/
   
3. Push the changes in the **master branch**

4. Go back to your SecOps instance => if everything goes well, you should see your new rules!
