#!/bin/bash

./entrypoint/utilities/extract-release.sh

echo "> Posting release note to Discord..."
MESSAGE="$(cat release_message)"
if [[ ${DISCORD_WEBHOOK_NAME} == "" && ${DISCORD_WEBHOOK_AVATAR} == "" ]]
then
  echo "Using default name and avatar"
  PAYLOAD=$(jq -n --arg content "${MESSAGE}" '$ARGS.named')
else
  if [[ ${DISCORD_WEBHOOK_NAME} == "" ]]
  then
    echo "Using default name"
    PAYLOAD=$(jq -n --arg avatar_url "${DISCORD_WEBHOOK_AVATAR}" --arg content "${MESSAGE}" '$ARGS.named')
  else
    if [[ ${DISCORD_WEBHOOK_AVATAR} == "" ]]
    then
      echo "Using default avatar"
      PAYLOAD=$(jq -n --arg username "${DISCORD_WEBHOOK_NAME}" --arg content "${MESSAGE}" '$ARGS.named')
    else
      PAYLOAD=$(
        jq -n \
        --arg username "${DISCORD_WEBHOOK_NAME}" \
        --arg avatar_url "${DISCORD_WEBHOOK_AVATAR}" \
        --arg content "${MESSAGE}" \
        '$ARGS.named'
      )
    fi
  fi
fi
STATUS_CODE=$(curl -s -L -X POST --json "${PAYLOAD}" -w "%{response_code}\n" -o /dev/null ${DISCORD_WEBHOOK_URL})
echo "Status: ${STATUS_CODE}"
if [ ${STATUS_CODE} -ne 204 ]; then exit 1; fi

echo "> Exporting release data to Action..."
echo "$(cat release_meta)" >> "${GITHUB_OUTPUT}"

exit 0
