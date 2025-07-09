#!/bin/bash

RELEASE=$(
  curl -s -L --oauth2-bearer ${GITHUB_TOKEN} \
  -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${GITHUB_REPO}/releases/tags/${GITHUB_TAG}"
)

echo "> Extracting release information from GitHub..."

# release meta
RELEASE_ID=$(echo -E ${RELEASE} | jq -r ".id")
RELEASE_NAME=$(echo -E ${RELEASE} | jq -r ".name")
RELEASE_URL=$(echo -E ${RELEASE} | jq -r ".html_url")
echo "release_id=${RELEASE_ID}" > release_meta
echo "release_name=${RELEASE_NAME}" >> release_meta
echo "release_url=${RELEASE_URL}" >> release_meta

# release note
RELEASE_NOTE=$(echo -E ${RELEASE} | jq -r ".body")
echo "# :new: [${RELEASE_NAME}](${RELEASE_URL}) is available now."$'\r\n\r\n'"${RELEASE_NOTE}" > release_message

exit 0
