import os
import boto3
import ssl
from dotenv import load_dotenv


class AmazonS3:
    def __init__(self):
        # Carregar as variáveis de ambiente do arquivo .env
        load_dotenv()
        self.bucket_name = 'data-lake-turma6-puc'
        self.aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID_1')
        self.aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY_1')
        self.region_name = 'sa-east-1'
        self.resource = 's3'
        ssl._create_default_https_context = ssl._create_unverified_context
        self.bucket = None

    def _connect_s3(self):
        try:
            session = boto3.Session(
                aws_access_key_id=self.aws_access_key_id,
                aws_secret_access_key=self.aws_secret_access_key,
                region_name=self.region_name
            )
            s3 = session.resource(self.resource)
            self.bucket = s3.Bucket(self.bucket_name)
        except Exception as e:
            print(f"Failed to connect to S3: {e}")

    def _put_object_bucket(self, local_path, amazon_path):
        amazon_destiny = os.path.join(amazon_path, os.path.basename(local_path))
        try:
            with open(local_path, 'rb') as data:
                self.bucket.put_object(Key=amazon_destiny, Body=data)
        except Exception as e:
            print(f"Failed to upload {local_path} to S3: {e}")
            return None
        url = f'https://{self.bucket_name}.s3.amazonaws.com/{amazon_destiny}'
        print(f"File uploaded to: {url}")
        return url

    def upload_file(self, local_path, amazon_path):
        self._connect_s3()
        return self._put_object_bucket(local_path, amazon_path)

    def upload_dataframe(self, df, file_name, amazon_path, file_format='csv'):
        local_path = f"{file_name}.{file_format}"
        if file_format == 'csv':
            df.to_csv(local_path, index=False)
        elif file_format == 'json':
            df.to_json(local_path, orient='records', lines=True)
        else:
            raise ValueError(f"Unsupported file format: {file_format}")
        return self.upload_file(local_path, amazon_path)

    def upload_local_file(self, local_file_name, amazon_path):
        local_path = os.path.join(os.getcwd(), local_file_name)
        if not os.path.isfile(local_path):
            raise FileNotFoundError(f"The file {local_path} does not exist.")
        return self.upload_file(local_path, amazon_path)


# Função para uso direto no notebook
def upload_to_s3(local_path, amazon_path):
    s3_uploader = AmazonS3()
    return s3_uploader.upload_file(local_path, amazon_path)
