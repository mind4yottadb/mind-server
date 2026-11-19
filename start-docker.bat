if [%1]==[] goto :noparam

set CONTAINER_NAME=%1%
docker compose up --force-recreate --detach --build
exit

:noparam
set CONTAINER_NAME=mind
docker compose up --force-recreate --detach --build
