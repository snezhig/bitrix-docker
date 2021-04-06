`# Bitrix-Docker starter

> The simple docker compose which has some containers for install bitrix and test it

> This docker using for dev, not for production

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [FAQ](#faq)
- [Support](#support)
- [License](#license)

# Features

* Configure php version 7.x by .env file
* Configure xdebug version 2.x or 3.x by .env file
* Mailhog for mail test
* Cron enabled
* Works from box in 90%

# Installation

#### Step 1

* Create a project dir `mkdir bxproject && cd ./bxproject`
* Clone the repository to have docker separate

``` shell
 git clone https://github.com/Snezhig/docker-compose-starter.git bxdocker
``` 

* Go to repository `cd ./bxdocker`

#### Step 3

* Make `init.sh` executable `chmod +x init.sh`

#### Step 4

* Run init script `./init.sh`
* It will create .env for docker-compose and ask you to type some paths

```
//parent dir by default, because i prefer have docker separate from project

# Type the project path: /home/snezhig/.dev/projects/private 
# Type the project name: private
# Type the domain for project: private.loc
# Type the path to docker data: /home/snezhig/.dev/projects/private/bitrix-docker/data
# Type the log path: /home/snezhig/.dev/projects/private/bitrix-docker/logs
# Type database name: test
# Type database user: test
# Type database user password: yourStrongPassword
# Type database root password: yourStrongPassword


```

#### Step 5

* Check .env file and correct it if need
* In case you need cron put path to bitrix in `./images/php/cron.d/www`

#### Step 6

* Build the docker

```
docker-compose up --build -d
```

* Then you can open `http://localhost` and see php info

---

#### Step 7

* Install bitrix in public directory as you wish

---

## Support

> I will be glad for your remarks about configuration and decor of readme

* <snezhig.git@gmail.com>

---

## License

[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

- [MIT license](http://opensource.org/licenses/mit-license.php)