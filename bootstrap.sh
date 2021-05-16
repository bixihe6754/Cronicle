#!/bin/bash

### This is for a test purpose. Remove it after test ###

rm -f *.md && rm -f *.json && rm -rf bin && rm -rf htdocs && rm -rf lib && rm -rf sample_conf && rm -rf node_modules && rm -rf conf && rm -rf logs && rm -rf queue

REDIS_HOST=us1-fun-dodo-33546.upstash.io
REDIS_PORT=33546
REDIS_PASSWORD=463933d1c71344388c268dce316ede16

########################################################



get_latest_release() {
	curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
		      grep '"tag_name":' |                                            # Get tag line
		          sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}


CRONICLE_LATEST_VERSION=$(get_latest_release "jhuckaby/Cronicle")

echo "Cronicle latest version: $CRONICLE_LATEST_VERSION"

CRONICLE_DIST_URL="https://github.com/jhuckaby/Cronicle/archive/$CRONICLE_LATEST_VERSION.tar.gz"

echo "Cronicle distribution URL: $CRONICLE_DIST_URL"

curl --silent -L $CRONICLE_DIST_URL | tar zxf - --strip-components 1

npm install --save

npm uninstall pixl-server-storage --save

npm install pixl-server-storage --save

npm install redis --save

node bin/build.js dist

echo "Updating config.json with Redis DB credentials"

CRONICLE_CONFIG_JSON_MODIFY_CMD="cat conf/config.json | jq '.Storage.engine = \"Redis\"' | jq '.Storage=(.Storage + {\"Redis\":{\"host\":\"$REDIS_HOST\",\"port\":$REDIS_PORT,\"password\":\"$REDIS_PASSWORD\",\"keyPrefix\":\"\"}})'"

CRONICLE_CONFIG_JSON_MODIFIED=$(eval "$CRONICLE_CONFIG_JSON_MODIFY_CMD")

echo $CRONICLE_CONFIG_JSON_MODIFIED | jq '.' > conf/config.json

echo "Successfully updated config.json with Redis DB credentials"

bin/control.sh setup

bin/control.sh start

sleep 10

bin/control.sh status


