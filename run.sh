# DB
docker run -d -p 5432 -e DB_NAME=mezzanine -e DB_USER=mezzanine -e PASSWORD=verydifficultstring --name db philipsahli/postgresql-test

sleep 10

# APP
ID=`docker run -d -p 80 --link db:db --name app docker-mezzanine`
echo $ID
PORT=`docker inspect $ID | python -c "import sys,json;j=json.loads(sys.stdin.read()); print j[0]['NetworkSettings']['Ports']['80/tcp'][0]['HostPort']"`
sleep 3
open http://localhost:$PORT
