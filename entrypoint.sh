#!/usr/bin/env bash
set -e

[[ ${NODIS_DEPLOY_ENV} == "qa" && ${DEPLOY_QA_TO_PROD} != "false" ]] && NODIS_DEPLOY_ENV="prod"
[[ ${NODIS_DEPLOY_ENV} == "qa" && ${DEPLOY_QA_TO_DEV} == "true" ]] && NODIS_DEPLOY_ENV="dev"

DISTRIBUTION_ID=`aws cloudfront list-distributions --query 'DistributionList.Items[?(Origins.Items[0].Id==`s3-'${NODIS_WEBAPP_BUCKET}'`)&&(Origins.Items[0].OriginPath==`/'${NODIS_DEPLOY_ENV}'`)].Id' --output text`

aws s3 cp s3://${NODIS_ARTIFACT_BUCKET}/${NODIS_PROJECT_NAME}/${NODIS_ARTIFACT_FILENAME} .

tar xzvf ${NODIS_ARTIFACT_FILENAME}

aws s3 sync --delete --acl private build s3://${NODIS_WEBAPP_BUCKET}/${NODIS_DEPLOY_ENV}-${NODIS_PROJECT_VERSION}

aws s3 sync --delete --acl public-read s3://${NODIS_WEBAPP_BUCKET}/${NODIS_DEPLOY_ENV}-${NODIS_PROJECT_VERSION} s3://${NODIS_WEBAPP_BUCKET}/${NODIS_DEPLOY_ENV}

aws cloudfront create-invalidation --distribution-id ${DISTRIBUTION_ID} --paths "/*"