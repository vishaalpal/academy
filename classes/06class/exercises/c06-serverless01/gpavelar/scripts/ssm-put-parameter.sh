# Create a String Parameter 
echo "Pushing ssm"
echo $DB_NAME
aws ssm put-parameter --name "DB_NAME" --value "$DB_NAME" --type SecureString --overwrite --region ap-southeast-2 > put-ssm-result.txt