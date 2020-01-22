#!/bin/bash

# Update Deadline
export POLICY_ID='polset-4mo721h3BJLeRda5'
export VAR_ID='var-SGkqCCEuZoAc7MkT'
export KEY='push_date'
export VALUE=$(date --utc +%FT%TZ)
curl -v -sk \
  --request PATCH \
  --data "{\"data\":{\"id\":\"$VAR_ID\",\"attributes\":{\"key\":\"$KEY\",\"value\":\"$VALUE\",\"category\":\"policy-set\",\"description\":null,\"hcl\":false,\"sensitive\":false,\"read-only\":false,\"relationships\":{\"configurable\":{\"data\":{\"type\":\"policy-sets\",\"id\":\"$POLICY_ID\"}}},\"type\":\"vars\"}}}" \
  -H "Content-type: application/vnd.api+json" \
  -H "Authorization: Bearer $TFE_TOKEN" \
  https://app.terraform.io/api/v2/policy-sets/$POLICY_ID/parameters/$VAR_ID

# Update version
# Remove leading 'v' from version number
export VAR_ID='var-gNi9dD6vjNuM34Rp'
export KEY='version'
export VALUE=$(echo $TRAVIS_TAG | sed -E 's/v?([0-9\.]+)/\1/')
curl -v -sk \
  --request PATCH \
  --data "{\"data\":{\"id\":\"$VAR_ID\",\"attributes\":{\"key\":\"$KEY\",\"value\":\"$VALUE\",\"category\":\"policy-set\",\"description\":null,\"hcl\":false,\"sensitive\":false,\"read-only\":false,\"relationships\":{\"configurable\":{\"data\":{\"type\":\"policy-sets\",\"id\":\"$POLICY_ID\"}}},\"type\":\"vars\"}}}" \
  -H "Content-type: application/vnd.api+json" \
  -H "Authorization: Bearer $TFE_TOKEN" \
  https://app.terraform.io/api/v2/policy-sets/$POLICY_ID/parameters/$VAR_ID


# Send email to consumers ( all teams using this module )
# Subject - Hey there is a new module. Sentinel will enforce the module usage
