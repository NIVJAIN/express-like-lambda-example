#!/usr/bin
npm run build
aws lambda update-function-code --function-name=express-like-lambda-example --zip-file=fileb://build/express-like-lambda-example.zip --region=ap-southeast-1 1> /dev/null

