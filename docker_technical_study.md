# Docker technical study

This is a technical study to learn how to use Docker to create a shared
development environment that behaves the same way irregardless of
what computer the environment is running on.

## What is docker?

"Docker makes development efficient and predictable
Docker takes away repetitive, mundane configuration tasks and is used throughout
the development lifecycle for fast, easy and portable application development –
desktop and cloud. Docker’s comprehensive end to end platform includes UIs, CLIs,
APIs and security that are engineered to work together across the entire
application delivery lifecycle." -
[Docker: Accelerated, Containerized Application Development](https://www.docker.com/)

A general desciption of Docker can be found on
[Wikipedia](https://en.wikipedia.org/wiki/Docker_(software)).

## Containerized software

From the information above we can deduce that Docker is used to create
containers of software. These containers ideally only contain the
minimal amount of software components needed to make the developed
application run and perform its tasks.

## Docker example

What this means is that a container can be created for each part of a
system. Let us consider a basic example of a web application with
a backend, a database and a frontend.

Let us assume that the backend is running
[Node.js](https://nodejs.org/en/), the database is
[MariaDB](https://mariadb.org/) and the frontend is running
[React](https://reactjs.org/).

There are several ways to make a container run. With our current
example we are looking to have containers talk to each other. Therefore
the suggested way of running our containers is using
[docker-compose](https://docs.docker.com/compose/).

Let us create a directory for each container. Let us also create the
file `docker-compose.xml` that will be used to run our containers.

```bash
.
├── docker-compose.yml
├── mariadb
├── node
└── react

3 directories, 1 file
```

Inside the directories we can create a `Dockerfile` that will describe
how to create the docker container for each component.

```bash
.
├── docker-compose.yml
├── mariadb
│   └── Dockerfile
├── node
│   └── Dockerfile
└── react
    └── Dockerfile

3 directories, 4 files

```

Let us also create subdirectories that will hold files that we want
each container to have access to.

```bash
.
├── docker-compose.yml
├── mariadb
│   ├── Dockerfile
│   └── sql
├── node
│   ├── app
│   └── Dockerfile
└── react
    ├── app
    └── Dockerfile

6 directories, 4 files
```

## Find images on Docker Hub

Software images are hosted at
[Docker Hub Container Image Library](https://hub.docker.com/) from where
we can pull images to our host computer.

There are usually several versions available, we will use
`latest` throughout the examples as it usually available.

## Create our Docker containers

Let us start by defining the
[node](https://hub.docker.com/_/node) container in
our `Dockerfile`.

```bash
.
└── node
    └── Dockerfile
```

```bash
FROM node:latest

WORKDIR /code

RUN npm install express nodemon
```

We will continue with the container for
[mariadb](https://hub.docker.com/_/mariadb).

```bash
.
└── mariadb
    ├── Dockerfile
```

```bash
FROM mariadb:latest
```

Finally we have the container for
[react](https://hub.docker.com/_/node) (which also uses node).

```bash
.
└── react
    └── Dockerfile
```

```bash
FROM node:latest

WORKDIR /code

# Only used for initial setup
RUN npx create-react-app .
```

## Run containers

Let us start by demonstrating how to start up a single container.

### Run the node (express) container

The easiest to test is most likely the backend. Some code needs to be
added for the backend to respond with a response. There is an example at
[Express "Hello World"](http://expressjs.com/en/starter/hello-world.html)

```bash
.
└── node
    └── app
        └── index.js
```

```bash
const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
```

We can run the container using `docker-compose`.

```bash
.
└── docker-compose.yml
```

```bash
version: "3.4"

services:

  node:
    container_name: node
    build: ./node
    command: /code/node_modules/.bin/nodemon /code/app/index.js
    volumes:
      - ./node/app:/code/app
    ports:
      - 3000:3000
    restart: on-failure
```

Explaination of commands:

```bash
version: "3.4"

services:

  node:
    container_name: <- The name that the container is accessed by
    build: <- The directory where the Dockerfile for the container is
    command: /code/node_modules/.bin/nodemon /code/app/index.js
    volumes: <- Map directories from the host to the container
      - <directory on host>:<directory in container>
    ports:
      - <host port>:<container port>
    restart: on-failure
```

Bring the container up by issuing `docker-compose up --build`.

```bash
❱ docker-compose up --build
Building node
Step 1/3 : FROM node:latest
 ---> cb9aad9080ca
Step 2/3 : WORKDIR /code
 ---> Using cache
 ---> e83c836efb28
Step 3/3 : RUN npm install express nodemon
 ---> Using cache
 ---> b659e8eefea9

Successfully built b659e8eefea9
Successfully tagged docker_node:latest
Recreating node ... done
Attaching to node
node    | [nodemon] 2.0.20
node    | [nodemon] to restart at any time, enter `rs`
node    | [nodemon] watching path(s): *.*
node    | [nodemon] watching extensions: js,mjs,json
node    | [nodemon] starting `node /code/app/index.js`
node    | Example app listening on port 3000
````

You can test the container by visiting [express](http://localhost:3000).

You can stop the containers with `CTRL+C`.

### Run the mariadb container

Let us proceed with `mariadb`.

```bash
.
└── docker-compose.yml
```

```bash
version: "3.4"

services:

   node:
    container_name: node
    build: ./node
    command: /code/node_modules/.bin/nodemon /code/app/index.js
    volumes:
      - ./node/app:/code/app
    ports:
      - 3000:3000
    restart: on-failure

   mariadb:
     container_name: maria
     image: mariadb:latest
     restart: always
     ports:
       - 3307:3306
     environment:
       MYSQL_ROOT_PASSWORD: example
       MYSQL_DATABASE: mydb
       MYSQL_USER: user
       MYSQL_PASSWORD: user
```
