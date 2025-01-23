rm -rf ./mobile/generated_api

openapi-generator-cli generate -i .\SWD392_8lind8ox\openapi\main.yml -g dart -o ./generated_api

echo "API client regenerated successfully!"
