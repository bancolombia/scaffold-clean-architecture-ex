set -e
BASE_IMAGE=$1
APP_NAME={app_snake}
mkdir -p _build
rm -rf _build/release
docker build --build-arg IMAGE=$BASE_IMAGE -t $APP_NAME -f resources/cloud/Dockerfile-build .
docker stop $APP_NAME || true
docker rm $APP_NAME || true
docker run -d --name $APP_NAME $APP_NAME
docker cp $APP_NAME:/app/_build/release _build/release
docker stop $APP_NAME || true
docker rm $APP_NAME || true
docker rmi $APP_NAME --force
cp -r deployment _build/release/artifact
ls -lR _build/release