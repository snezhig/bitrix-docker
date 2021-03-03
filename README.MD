# Docker compose starter
> The simple docker compose which has some containers for fast start


## Table of Contents


- [Installation](#installation)
- [FAQ](#faq)
- [Features](#features)
- [Support](#support)
- [License](#license)


# Installation

#### Step 1
> Clone the project
 ```
 git clone https://github.com/Snezhig/docker-compose-starter.git`
``` 
#### Step 2
> Go to project
```
cd docker-compose-starter
```
#### Step 3
> Make `init.sh` executable
```
chmod +x init.sh
```
#### Step 4
> Run init script
```
./init.sh
```
> It will create .env for docker-compose and ask you to type some paths
```
~/projects/docker-compose-starter$ ./init.sh

# Type the project name: docker_compose_starter
# Type the project path: /x/projects/docker-compose-starter
# Type the path to docker data: /x/projects/docker-compose-starter/docker/data
# Type the log path: /x/projects/docker-compose-starter/docker/logs
# Type database name: docker_db
# Type database user: docker_user
# Type database user password: docker_pass
# Type database root password: docker_root_pass
# Create public folder with index.php? Y

```

#### Step 5
> Build the docker
```
docker-compose up --build -d
```
> Then you can open `http://localhost` and see php info

---

# FAQ
* Why there is `open-ssh-server` in php container?
    * I work on Windows I couldn't connect IDE with docker-compose, namely to give access to php interpreter to run tests from IDE, so I decided to connect by ssh to do it

---
# Features
## .env file
> Most of them understandable by name, but I will describe some
* `COMPOSE_PROJECT_NAME`: used as a prefix for containers
* `PROJECT_PATH`: path for `project` volume. Will be filled by `init.sh`
* `LOGS_PATH`: path for `logs` volume. Will be filled by `init.sh`
* `DATA_PATH`: path for docker data (E.g database)
* `SET_UP_SSH_SERVER`: If it is true docker will install `ssh server` and runs it and php-frm by supervisord
* `XDEBUG_HOST`: `host.docker.internal` works for windows

---

# What's next
* [ ] Complement README
* [ ] Add variable for php extensions
* [x] Add mysql container

---

# Support
> I will glad for your remarks about configuration and decor of readme 
* <snezhig.git@gmail.com>
---

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- **[MIT license](http://opensource.org/licenses/mit-license.php)**