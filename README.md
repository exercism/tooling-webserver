# Exercism Local Tooling Webserver

This small webhook wrapper is used when tooling (analyzers/representers/test runners) runs inside the Docker development environment. Since they cannot be launched via `runc` in this environment we need an alternative. The [Tooling Invoker](https://github.com/exercism/tooling-invoker/) instead dispatches a web request. This tiny web server responds to those requests, wraps the underlying `./run.sh` test runner script, and returns the JSON output file as a simple JSON response.

## Installation (Docker)

The compiled stand-alone binary should be added directly into your tooling's Docker image. Here are some Dockerfile commands to use `curl` or `wget` to include the binary into your Docker image:

```dockerfile
# inside your Dockerfile
RUN curl -L -o /usr/local/bin/exercism_local_tooling_webserver \
      https://github.com/exercism/local-tooling-webserver/releases/download/latest/exercism_local_tooling_webserver && \
    chmod +x /usr/local/bin/exercism_local_tooling_webserver
```

or

```dockerfile
# inside your Dockerfile
RUN wget -P /usr/local/bin https://github.com/exercism/local-tooling-webserver/releases/latest/download/exercism_local_tooling_webserver && \
    chmod +x /usr/local/bin/exercism_local_tooling_webserver
```

See [this Dockerfile](https://github.com/exercism/javascript-test-runner/blob/master/Dockerfile#L33) for an example on how to include the tooling into a Docker image.

The above allows the [development environment](https://github.com/exercism/development-environment/) to run the tooling as a Docker container but with a modified entrypoint:

```yaml
javascript-test-runner:
  entrypoint: exercism_local_tooling_webserver
```

## Installation (Ruby)

Add this line to your application's Gemfile:

```ruby
gem 'exercism-local-tooling-webserver'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install exercism-local-tooling-webserver

## Testing with Curl

An example:

```bash
curl 'http://localhost:4567/job' -H 'Expect:' \
  -d exercise=two-fer \
  -d results_filepath=results.json \
  --data-urlencode zipped_files@test.zip
```

The zip archive should include the exercise solution and tests. For this to work you'll have to expose port 4567. If you're using `v3-docker-compose` you can simply modify your `stack.yml`:

```yaml
configure:
  javascript-test-runner:
    build: true
    ports:
      - 4567:4567
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Building using Docker

If you'd prefer not to install Nim but would still like to be able to build the binary, you can do so if you have Docker installed. To build the binary, run:

```bash
./bin/build
```

This will build the binary inside a Docker container and copy the built binary to the current directory.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/exercism-local-tooling-webserver.
