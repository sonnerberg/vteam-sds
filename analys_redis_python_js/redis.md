# Redis - kompabilitet med Python och JavaScript

## TL;DR
Om vi vill komma igång med Redis så är språket förmodligen inte avgörande. Det finns klienter till både Python och JavaScript som verkar ganska enkla att komma igång med om vi bara vill skriva till och läsa från Redis. Det vi förmodligen behöver fundera över är om Redis är "overkill" för det vi vill göra. Den bästa strategin framåt är nog att undersöka om (och var) flaskhalsar uppstår och i så fall om det finns andra sätt att lösa dem. Om inte skulle Redis kunna vara ett alternativ att titta närmare på.

## Bakgrund
Vi har på våra inledande möten diskuterat hur vi ska hantera en eventuell hög belastning mot databasen främst när det gäller data från elsparkcyklarna som behöver uppdateras ofta. Ett sätt att lösa detta skulle kunna vara att implementera en cache. Redis är ett datastrukturslager som lever i minnet och som kan användas som en databas, en cache "message broker" m.m.[1] Eftersom vi just nu befinner oss i fasen att börja välja språk och tekniker som vi ska använda framöver och vi funderar på om vi ska välja Python eller JavaScript när vi skriver backend är det läge att ta reda på om Redis fungerar bättre med det ena eller andra språket.

## Eventuella fördelar
Att hämta och skriva information till disk tar tid. Fördelen med att använda Redis som en cache mellan databas och API skulle vara att kunna hämta information från cachen istället för databasen och att skriva information till cachen först och sedan skriva till databasen mer sällan för att inte behöva läsa och skriva till disk så ofta.

## Att använda Redis
Det första vi behöver är en Redis instans, det finns en officiell Docker container som kan användas för att starta upp en Redis instans.[2] För att sedan använda Redis från en applikation behövs en klient för det akutella programmeringsspråket. Redis dokumentation listar flera klienter för både Python och JavaScript. De mest populära verkar vara node-redis (155535 stjärnor på Github) för JS och redis-py (10763 stjärnor) för Python.[3] Vi kan alltså konstatera att det finns klienter för båda språken och att båda klienterna är listade som rekommenderade och som aktiva repon. Nedan används aioredis som kan hantera asynkrona anrop till Redis och numera är en del av redis-py.[4]

Ett enkelt sätt att testa hur det fungerar att koppla sig till Redis och skriva och läsa med de olika klienterna är att starta upp ett litet nätverk av Docker-containrar, ett sådant testnätverk med en Express-server och en FastAPI-server som sätter och hämtar ett värde från Redis kan sättas upp så som följer.

### Struktur:
```
.
├── docker-compose.yml
├── express
│   ├── app
│   │   └── index.js
│   └── Dockerfile
├── fastapi
│   ├── app
│   │   ├── __init__.py
│   │   ├── main.py
│   ├── Dockerfile
│   └── requirements.txt

```
### docker-compose.yml

```
version: "3.4"

services:

  redis:
    container_name: myredis
    image: redis

  express:
    container_name: express
    build: ./express
    working_dir: /code/app
    command: /code/node_modules/.bin/nodemon /code/app/index.js
    volumes:
      - ./express/app:/code/app
    ports:
      - 8081:3000
    restart: on-failure

  fastapi:
    container_name: fastapi
    build: ./fastapi
    working_dir: /code/app
    command: uvicorn main:app --host 0.0.0.0 --reload
    environment:
      DEBUG: 1
    volumes:
      - ./fastapi/app:/code/app
    ports:
      - 8082:8000
    restart: on-failure
```
### Docker file för servicen express:

```
FROM node:latest

WORKDIR /code

RUN npm install express nodemon redis
```

Docker file för servicen fastapi:

```
FROM python:latest


COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
```

### requirements.txt

```
fastapi>=0.68.0,<0.69.0
pydantic>=1.8.0,<2.0.0
uvicorn>=0.15.0,<0.16.0
redis>=4.2.0rc1
```

### index.js
```
const redis = require('redis');
const express = require('express')
const app = express()
const port = 3000

async function connectAndSet() {
    const client = redis.createClient({socket: {host: 'myredis', port: 6379}});

    client.on('error', (err) => console.log('Redis Client Error', err));

    await client.connect();
    await client.set('expresskey', 'Express value');
    await client.disconnect();
}

async function connectAndGet() {
    const client = redis.createClient({socket: {host: 'myredis', port: 6379}});

    client.on('error', (err) => console.log('Redis Client Error', err));

    await client.connect();
    const value = await client.get('expresskey');
    console.log(value);
    await client.disconnect();
    console.log(value);
    return value;
}


app.get('/', async (req, res) => {
  await connectAndSet();
  const value = await connectAndGet();
  res.json({value: value});
});


app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
});
```

main.py
```
from fastapi import FastAPI
from redis import asyncio as aioredis
app = FastAPI()

async def connectAndSet():
    redis = aioredis.from_url('redis://myredis')
    await redis.set('pythonkey', 'Python value')

async def connectAndGet():
    redis = aioredis.from_url('redis://myredis')
    value = await redis.get('pythonkey')
    return value

@app.get("/")
async def read_root():
    await connectAndSet()
    value = await connectAndGet()
    return {value}
```

För att starta kör: docker-compose up --build. Öppna sedan en webbläsare och rikta mot localhost:8081 för express och 8082 för FastAPI för att se den data som har satts och hämtas via Redis.


## Hur skulle Redis kunna användas i projektet?

### Läsa från cachen
Grundtillvägagångssättet är sådant att när applikationen ska hämta data så låter man den först göra en förfrågan (via en Redis-klient) som ovan till Redis för att se om värdet finns där. Om det inte gör det gör applikationen istället en förfrågan till databasen, hämtar informationen och sparar den sedan i Redis (tex. på det sätt som görs i de enkla exemplen nedan). Nästa gång informationen behövs finns den i Redis. När jag har sökt runt efter exempel finns det många bra kodexempel på hur man kan använda Redis för att lagra data i cache och sedan läsa från cachen istället för från databasen eller ett API.[5] 

### Skriva till cachen
I vårt fall har vi dock troligen problem med att data uppdateras väldigt ofta - det vi kanske främst behöver är något som kan se till att det inte blir för mycket skrivningar till databasen på för kort tid. En sådan strategi är "write behind" - d.v.s. att man inte skriver data direkt till databasen utan lagrar den i cachen och sedan skriver data efter ett tag. Här verkar det vara lite mer knepigt att komma igång på ett enkelt sätt. Ett möjligt sätt verkar vara att använda RedisGears (Python) och "recept" för att få detta att fungera.[6] Ett annat sätt är göra det själv t.ex. genom att spara en hash i Redis med det som elsparkcyklarna skriver till databasen och timestamps och sedan med jämna mellanrum kolla av denna från backend och när data "legat ett tag" i Redis så skrivs den till databasen. 

Vi skulle också kunna strunta helt i att använda en "traditionell" databas och bara använda Redis eftersom Redis också kan skriva till disk med jämna mellanrum.

Förmodligen behöver man klura en del här för att till det på rätt sätt med Redis. En viktig fråga vi måste ställa oss är om vi "behöver" Redis som en cache eller om detta kan lösas enklare i vårt projekt. Förmodligen är det vettigaste tillvägagångssättet att först se om vi får problem med flaskhalsar för att sedan överväga sätt att hantera dem.

## Säkerhet
Redis är ett mycket öppet system, filosofin är att det ska vara lätt att komma igång med och att användaren själv måste göra det som går för att skydda sig och sin data. Detta är något som måste övervägas om vi vill sätta in Redis i produktion.[7] Att testa grundläggande funktioner i några Docker-containrar är relativt enkelt men att sätta systemet i produktion "på riktigt" kan vara något helt annat.

## Slutsats
Vad jag kan se är det inte avgörande vilket språk vi använder om vi vill köra Redis. Vill vi köra "write behind" så finns det lösningar på "Python-sidan" men frågan är om de inte är "overkill" och att vi iställt i så fall bör fokusera på en egen lösning. Detta kan också gälla för hela Redis - troligen är den bästa vägen framåt nu att testa och se om vi råkar ut för flaskhalsar, gör vi det bör vi nog först fokusera på att hitta enkla sätt att komma förbi dem men om det inte går skulle Redis kunna vara ett alternativ att överväga.




[1] Se https://redis.io/docs/about/

[2] Se https://hub.docker.com/_/redis

[3] Se https://redis.io/resources/clients/

[4] Se https://github.com/aio-libs/aioredis-py

[5] Se t.ex. https://www.digitalocean.com/community/tutorials/how-to-implement-caching-in-node-js-using-redis

[6] Se https://github.com/RedisGears/rgsync

[7] Se https://redis.io/docs/getting-started/