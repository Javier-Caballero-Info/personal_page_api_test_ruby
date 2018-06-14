# Personal Page Storage API Test - Ruby

> Ruby app to test API with rspec

## Table of Contents

-   [Overview](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master/README.md#overview)
-   [Clone](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master/README.md#clone)
- [Requirements](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#requirements)
- [Installation](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#installation)
	- [ruby](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#ruby)
	- [Dependencies](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#dependencies)
- [Environment](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#environment)
- [Run test](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#run-test)
- [Build](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#build)
- [Running with Docker](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#running-with-docker)
	- [Building the image](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#building-the-image)
	- [Starting up a container](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#starting-up-a-container)
- [Contributing](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#contributing)
- [Author](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#author)
- [License](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/tree/master#license)

## Overview

This project is a collection of different test suites that test all the API in the project. The concept here is create a
docker network with all the apis and run the test to proves the integrity and the functionality of each microservice.

This test should not replace the unit test in every project. Because the objective is simulate the real world.

## Clone

```bash
git clone https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby.git
git remote rm origin
git remote add origin <your-git-path>
```

## Requirements

* **Ruby:** 2.3.0 or above

## Installation

1. ### Ruby

    - Debian / Ubuntu

        ```Bash
        sudo apt install ruby-full
        ```
        
    - MacOS
    
        - Brew
            ```bash
            brew install ruby
            ```

    - Windows

        - Installer

            Download the msi installer [https://rubyinstaller.org/](https://rubyinstaller.org/).


2. ### Dependencies

    ```Bash
    bundle install
    ```

## Environment

Export the following environment variables:

```bash
PORT=3000
JWT_SIGN_ALGORITHM=HS256 # Signature to validate the JWT token
JWT_SECRET_KEY=secret # Secret key for jwt

# General Information
BASE_PATH_AUTH=http://localhost:3100
BASE_PATH_ADMIN=http://localhost:3000
BASE_PATH_STORAGE=http://localhost:3200
RIGHT_USERNAME=admin
RIGHT_PASSWORD=admin
WRONG_USERNAME=wrong
WRONG_PASSWORD=wrong
```

## Run test

```Bash
rspec spec/*_spec.rb
```

## Build

No build needed


## Running with Docker

To run the server on a Docker container, please execute the following from the root directory:

### Building the image
```bash
docker build -t personal_page_api_test_ruby .
```
### Starting up a container
```bash
docker run -p 3000:3000 -d \
-e JWT_SECRET_KEY="jwt-secret-string" \
-e JWT_SIGN_ALGORITHM="HS256" \
-e BASE_PATH_AUTH="http://localhost:3100" \
-e BASE_PATH_ADMIN="http://localhost:3000" \
-e BASE_PATH_STORAGE="http://localhost:3200" \
-e RIGHT_USERNAME="admin" \
-e RIGHT_PASSWORD="admin" \
-e WRONG_USERNAME="wrong" \
-e WRONG_PASSWORD="wrong" \
personal_page_api_test_ruby
```
## Contributing

Contributions welcome! See the  [Contributing Guide](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/blob/master/CONTRIBUTING.md).

## Author

Created and maintained by [Javier Hernán Caballero García](https://javiercaballero.info)).

## License

GNU General Public License v3.0

See  [LICENSE](https://github.com/Javier-Caballero-Info/personal_page_api_test_ruby/blob/master/LICENSE)
