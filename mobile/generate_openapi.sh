rm -rf ./mobile/generated_api

openapi-generator-cli generate -i C:/Duyen_needs/University/Semester07_Spring2025/SWD392/SWD392_8lind8ox/openapi/main.yml -g dart -o ./generated_api

echo "API client regenerated successfully!"
