-- create file format
CREATE FILE FORMAT IF NOT EXISTS csv_format
  TYPE = 'CSV' 
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;

-- Create Stage Pointing to AWS S3
CREATE OR REPLACE STAGE snowstage
FILE_FORMAT = csv_format
URL='s3://snowbucket_jay/source/';

SHOW STAGES; -- display external stages which is s3 location
    
-- Execute the COPY INTO statement to load data from the S3 stage into your target table (Create IAM user for credentials)
COPY INTO BOOKINGS
FRoM @snowstage
FILES=('Bookings.csv')
CREDENTIALS=(aws_key_id = 'yourkey', aws_secret_key = 'yoursecretkey');

COPY INTO HOSTS
FRoM @snowstage
FILES=('Hosts.csv')
CREDENTIALS=(aws_key_id = 'yourkey', aws_secret_key = 'yoursecretkey');

COPY INTO LISTINGS
FRoM @snowstage
FILES=('Listings.csv')
CREDENTIALS=(aws_key_id = 'yourkey', aws_secret_key = 'yoursecretkey');


select * from BOOKINGS