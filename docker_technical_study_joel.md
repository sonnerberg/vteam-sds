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
file `docker-compose.yml` that will be used to run our containers.

```bash
.
├── docker-compose.yml
├── mariadb
├── node
└── react

3 directories, 1 file
```

Inside the directory for node we can create a `Dockerfile` that will describe
how to create the docker container for the component.

```bash
.
├── node
   └── Dockerfile


```

Let us also create subdirectories that will hold files that we want
each container to have access to.

```bash
.
├── docker-compose.yml
├── mariadb
│   ├── sql
├── node
│   ├── app
│   └── Dockerfile
└── react
    ├── app

```

## Find images on Docker Hub

Software images are hosted at
[Docker Hub Container Image Library](https://hub.docker.com/) from where
we can pull images to our host computer.

There are usually several versions available, we will use
`latest` throughout the examples as it is usually available.

## Docker image for node

Let us start by defining the
[node](https://hub.docker.com/_/node) container in
our `Dockerfile` for Express.

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

We will specify which images to use for the other components in the docker-compose.yml file.

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

Explanation of commands:

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

Bring the container up by issuing `docker-compose up --build`. When running docker-compose up a network named "your app dir"_default is created and all services defined in docker-compose.yml joins this network under their names.

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
```

You can test the container by visiting [express](http://localhost:3000).

To stop the containers and take down the network, open a new terminal window go to your app directory and issue: ```docker-compose down```

### Run the mariadb container

Let us proceed with `mariadb`.

```bash
.
└── docker-compose.yml
```

We can specify an image to use in docker-compose.yml. Here we are using mariadb:latest: [mariadb](https://hub.docker.com/_/mariadb).

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
    volumes:
     - ./mariadb/sql:/docker-entrypoint-initdb.d
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: user
```

We are mapping ./mariadb/sql to /docker-entrypoint-initdb.d in the container. All SQL files in
/docker-entrypoint-initdb.d will be executed when the container starts and be imported by default to the database specified by the MYSQL_DATABASE variable in docker-compose.yml.

Let us add a some SQL to a file, setup.sql, in mariadb/sql

```bash
.
└── mariadb
    └── sql
        └── setup.sql
```

```bash
DROP TABLE IF EXISTS `data`;

CREATE TABLE IF NOT EXISTS `data` (
`id` INT NOT NULL AUTO_INCREMENT,
`greeting` VARCHAR(250),
PRIMARY KEY (`id`))
ENGINE = InnoDB
CHARSET utf8
COLLATE utf8_swedish_ci
;

INSERT INTO `data` (`greeting`)
VALUES
    ("Hello from MariaDB")
; 
```

To start both containers and the network as above issue: `docker-compose up --build`

If you want to connect a command line client to the maria container´s MariaDB instance you can do so by opening a new terminal window and issue:

```
docker run -it --network <default network name> --rm mariadb mariadb -hmaria -uuser -p
```
As explained at [https://hub.docker.com/mariadb](https://hub.docker.com/mariadb) this command starts another mariadb container instance and runs the command line client against the original mariadb container. So if you are running your app in a directory called vteam the command would be:

```
docker run -it --network vteam_default --rm mariadb mariadb -hmaria -uuser -p
```

Enter the user password (user) and you can enter some SQL queries, maybe see if there is a database called mydb and a table called data? Exit the MariaDB instance and the container by typing exit.

You can stop the containers and take down the network by opening a new terminal and go to your app directory issuing: ```docker-compose down```

### Run the React container

```bash
.
└── react
    └── app
```

First we have to create the react app that we will be using in the container. Go to the directory react/app and run the command: ```npx create-react-app .```

Then add the service to docker-compose.yml here we are again specifying an image to use and for our react container we are going to use node: [react](https://hub.docker.com/_/node)

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
    volumes:
     - ./mariadb/sql:/docker-entrypoint-initdb.d
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: user

  react:
    container_name: react
    image: node:latest
    working_dir: /code/app
    command: npm start
    volumes:
      - ./react/app:/code/app
    ports:
      - 8083:3000
    restart: on-failure
```

Issue: `docker-compose up --build` to start everything. Now you can visit [http://localhost:8083](http://localhost:8083) to see the react app running.

You can stop the containers and take down the network by opening a new terminal and go to your app directory issuing: ```docker-compose down```

## Using the containers together
We can now use the containers together. We begin by connecting to the MariaDB instance from the node container. To do this we need to install the MariaDB Node.js Connector. We can do this in the Docker file in the node directory:

```bash
.
└── node
    └── Dockerfile
```

```bash
FROM node:latest

WORKDIR /code

RUN npm install express nodemon mariadb
```

Then we add some code to node/index.js, there is an example at [https://mariadb.com/kb/en/getting-started-with-the-nodejs-connector/](https://mariadb.com/kb/en/getting-started-with-the-nodejs-connector/) which we modify below.

```bash
.
└── node
    └── app
        └── index.js
```

```bash
const express = require('express')
const cors = require("cors");
const app = express()
const port = 3000

app.use(cors());
app.options('http://localhost:8083', cors());

const mariadb = require('mariadb');
const pool = mariadb.createPool({
    host: 'mariadb', 
    user:'user', 
    password: 'user',
    database: 'mydb',
    connectionLimit: 5
});

async function asyncFunction() {
  let conn;
  try {
  conn = await pool.getConnection();
  const rows = await conn.query("SELECT * FROM data");
  console.log(rows);
  return rows;

  } catch (err) {
    throw err;
  } finally {
  if (conn) {
    conn.end();
  }
  }
}

app.get('/', async (req, res) => {
  const rows = await asyncFunction();
  res.json(rows[0].greeting);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
});
```
Issue: `docker-compose up --build` to start everything. You can now visit [http://localhost:3000](http://localhost:3000) to see the the data the express app has fetched from the MariaDB instance in the maria container.

You can stop the containers and take down the network by opening a new terminal and go to your app directory issuing: ```docker-compose down```

### Fetch data with React
We can also add some code to our react/app/app.js file to get the data from the express instance. Note in this example we are using fetch in the React app to fetch data from localhost:3000 where the node/express app is running. This is because the web browser does not know anything about the docker network so we can not fetch the data from the docker network to the React app.

To be able to connect to the Express app we need to enable cross-origin-resource sharing in the Express app. We are using the cors npm-package for this.

```bash
.
└── node
    └── Dockerfile
```

```bash
FROM node:latest

WORKDIR /code

RUN npm install express nodemon mariadb cors
```
Then we set up cors between the Express app and localhost:8083 where the React app is running.
```bash
.
└── node
    └── app
        └── index.js
```

```bash
const express = require('express')
const cors = require("cors");
const app = express()
const port = 3000

app.use(cors());
app.options('http://localhost:8083', cors());

const mariadb = require('mariadb');
const pool = mariadb.createPool({
     host: 'mariadb', 
     user:'user', 
     password: 'user',
     connectionLimit: 5
});

async function asyncFunction() {
  let conn;
  try {
  conn = await pool.getConnection();
  const rows = await conn.query("SELECT 'Hello from mariadb' as val");
  console.log(rows);
  return rows;

  } catch (err) {
    throw err;
  } finally {
  if (conn) {
    conn.end();
  }
  }
}


app.get('/', async (req, res) => {
  const rows = await asyncFunction();
  res.json(rows[0].val);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
});
```

Then we add a button with a function to fetch and display data from the Express app (which gets its data from the maria container). Add a Button.js file in the react/app directory

```bash
.
└── react
    └── app
        └── Button.js
```

Add this to the file:

```bash
export default  function Button({handleClick}) {

    return (
            <button onClick={handleClick}>Fetch data</button> 
    );
};

```

Then modify react/app/App.js:

```bash
.
└── react
    └── app
        └── App.js
```

```bash
import logo from './logo.svg';
import './App.css';
import Button from './Button';
import { useRef, useState } from 'react';

function App() {
  const [message, setMessage] = useState('');

  async function handleClick() {
    const response = await fetch('http://localhost:3000/');
    const result = await response.json();
    setMessage(result);
  }

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>

        <Button handleClick={handleClick} />
        <div>{message}</div>
      </header>
    </div>
  );
}

export default App;

```

Issue: `docker-compose up --build` to start everything. Now you can visit [http://localhost:8083](http://localhost:8083) and click the button "Fetch data" to see a message displayed. This message is fetched from the Express app at localhost:3000 which in turn gets it´s data from the MariaDB instance running in the maria container.

## Conclusion
In the way demonstrated in this study we can set up a network of Docker containers in a default network and let them "talk" to each other.