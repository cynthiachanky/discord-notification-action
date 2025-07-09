#!/bin/bash

echo "> Deleting release ${RELEASE_ID}..."
STATUS_CODE=$(
  curl -s -L -X DELETE --oauth2-bearer ${GITHUB_TOKEN} \
  -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
  -w "%{response_code}\n" -o /dev/null \
  "https://api.github.com/repos/${GITHUB_REPO}/releases/${RELEASE_ID}"
)
echo "Status: ${STATUS_CODE}"
if [ ${STATUS_CODE} -ne 204 ]; then exit 1; fi

echo "> Deleting tag ${TAG_REF}..."
STATUS_CODE=$(
  curl -s -L -X DELETE --oauth2-bearer ${GITHUB_TOKEN} \
  -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" \
  -w "%{response_code}\n" -o /dev/null \
  "https://api.github.com/repos/${GITHUB_REPO}/git/${TAG_REF}"
)
echo "Status: ${STATUS_CODE}"
if [ ${STATUS_CODE} -ne 204 ]; then exit 1; fi

exit 0
