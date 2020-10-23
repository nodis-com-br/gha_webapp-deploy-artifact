#!/usr/bin/env bash
set -e

[[ ${NODIS_DEPLOY_ENV} == "qa" && ${DEPLOY_QA_TO_PROD} != "false" ]] && NODIS_DEPLOY_ENV="prod"
[[ ${NODIS_DEPLOY_ENV} == "qa" && ${DEPLOY_QA_TO_DEV} == "true" ]] && NODIS_DEPLOY_ENV="dev"

aws s3 cp s3://${NODIS_ARTIFACT_BUCKET}/${NODIS_PROJECT_NAME}/${NODIS_ARTIFACT_FILENAME} .

tar xzvf ${NODIS_ARTIFACT_FILENAME}

aws s3 sync --delete s3://${NODIS_WEBAPP_BUCKET}/${NODIS_DEPLOY_ENV} s3://${NODIS_WEBAPP_BUCKET}/${NODIS_DEPLOY_ENV}-old

aws s3 sync --delete build s3://${NODIS_WEBAPP_BUCKET}/${NODIS_DEPLOY_ENV}
