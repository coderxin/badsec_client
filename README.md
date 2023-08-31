# BadsecClient

Retrieves the user ID list from the BADSEC server and outputs it in JSON format.

> ## Noclist
>
> The problem: https://homework.adhoc.team/noclist/
> 
> ---
> 
> Retrieve the NOC list
> The Bureau of Adversarial Dossiers and Securely Encrypted Code (BADSEC) has asked you to retrieve a list of VIP users. Fortunately, BADSEC provides an API to the agency you've been working with. Unfortunately, it's not the best API in the world.
> 
> Your job is to write a program that securely and politely asks the BADSEC server for this list of users and prints it to stdout in JSON format.
> 
> As the server that your application will be hitting is not well written, you should seek to minimize the amount of communication it does. Furthermore, you should write a client that is resilient to errors in the server.

## Requirements

- Ruby `3.2.2`
- Docker (latest)

### Local setup

Using RVM:

```bash
rvm install ruby-3.2.2
rvm use ruby-3.2.2@badsec_client --create
gem install bundler:2.4
bundle install
```

### Running the app

In order to start the application, BADSEC development server has to be start first. Please using this docker command to start the server:

```sh
docker run --rm -p 8888:8888 adhocteam/noclist
```

When BADSEC server has been started, please run the script the following script:

```sh
bin/run
```
### Running specs

In order to run Rspec specs, please use the following command:
```bash
bundle exec rspec 
```
### Running linter

In order to run Rubocop linter, please use the following command:

```bash
bundle exec rubocop 
```

### Running the console

The command below does load the `badsec_client` code in the context of IRB:

```sh
bin/console
```

Usage example:

```
3.2.2 :001 > client = BadsecClient::Client.new
 =>
#<BadsecClient::Client:0x00000001036bc548
 @connection=
  #<BadsecClient::Connection:0x00000001036bba58
   @access_token=nil,
   @config=#<BadsecClient::Config:0x00000001036bc2a0 @host="localhost:8888", @max_failure_retry_attempts=2>>>

3.2.2 :002 > client.authenticate!
 =>
#<BadsecClient::Connection:0x0000000106c80918
 @access_token="0C85789B-B2C2-FC90-01B0-FA4127D5E69A",
 @config=#<BadsecClient::Config:0x0000000106c80940 @host="localhost:8888", @max_failure_retry_attempts=2>>

3.2.2 :003 > users_resource = client.users
 =>
#<BadsecClient::Resources::User:0x0000000106f2a628
 @connection=
  #<BadsecClient::Connection:0x0000000106c80918
   @access_token="0C85789B-B2C2-FC90-01B0-FA4127D5E69A",
   @config=#<BadsecClient::Config:0x0000000106c80940 @host="localhost:8888", @max_failure_retry_attempts=2>>>

3.2.2 :004 > users_resource.list
 =>
["18207056982152612516", ... ,"7692335473348482352"]

3.2.2 :012 > BadsecClient::Formatters::Json.format(users_resource.list)
 => "[\"18207056982152612516\", ...,\"7692335473348482352\"]"
```
