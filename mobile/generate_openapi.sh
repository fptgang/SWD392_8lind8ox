if [ "$OSTYPE" = "msys" ] || [ "$OSTYPE" = "win32" ]; then
    openapi-generator-cli generate -i ../openapi/main.yml -g dart -o ./generated_api

else
    openapi-generator generate -i ../openapi/main.yml -g dart -o ./generated_api
fi

echo "API client regenerated successfully!"

rm -rf ./generated_api/lib/model/page.dart
# copy the copyablepagedart file to the correct location
cp ./temp/copyablepagedart ./generated_api/lib/model/page.dart