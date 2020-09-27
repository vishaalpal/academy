echo "Getting ssm"
aws ssm get-parameter \
    --name "DB_NAME" \
    --with-decryption > get_ssm_result.txt