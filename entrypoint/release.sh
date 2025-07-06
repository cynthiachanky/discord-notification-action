#!/bin/bash

RELEASE=$(
  curl -s -L --oauth2-bearer ${GITHUB_TOKEN} \
  -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${GITHUB_REPO}/releases/tags/${GITHUB_TAG}"
)

echo "> Extracting release information from GitHub..."
RELEASE_ID=$(echo -E ${RELEASE} | jq -r ".id")
RELEASE_NAME=$(echo -E ${RELEASE} | jq -r ".name")
RELEASE_NOTE=$(echo -E ${RELEASE} | jq -r ".body")

echo "> Posting release note to Discord..."
MESSAGE="# :new: [${RELEASE_NAME}](https://github.com/${GITHUB_REPO}/releases/tag/${GITHUB_TAG}) is available now."$'\r\n\r\n'"${RELEASE_NOTE}"
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
echo "release_id=${RELEASE_ID}" >> "${GITHUB_OUTPUT}"
echo "release_name=${RELEASE_NAME}" >> "${GITHUB_OUTPUT}"

exit 0
