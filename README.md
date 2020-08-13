# Exercism Local Tooling Webserver

This small webhook wrapper is used when test runners are running inside the Docker development environment.  Since they cannot be launched via runc in this environment we need an alternative.  Tooling Invoker instead dispatches a web request.  This tiny web server responds to those requests, wraps the underlying `./run.sh` test runner script, and returns the JSON output file as a simple JSON response.

## Installation (Ruby)

Add this line to your application's Gemfile:

```ruby
gem 'exercism-local-tooling-webserver'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install exercism-local-tooling-webserver

## Usage / Installation (Nim binary)

The compiled stand-alone binary is intended to simply be added directly into your test runner's build:

```dockerfile
# inside your dockerfile
ARG webhook_version=0.5.0
RUN curl -L -o /usr/local/bin/exercism_local_tooling_webserver \
  https://github.com/exercism/local-tooling-webserver/releases/download/${webhook_version}/exercism_local_tooling_webserver
RUN chmod +x /usr/local/bin/exercism_local_tooling_webserver
```

And then the `entrypoint` is modified when running in development mode:

```yaml
javascript-test-runner:
  entrypoint: exercism_local_tooling_webserver
```

## Testing with Curl

An example:

```bash
curl 'http://localhost:4567/job' -H 'Expect:' \
  -F zipped_files="<test.zip" \
  -F exercise=two-fer \
  -F results_filepath=results.json
```

The zip archive should include the exercise solution and tests.  For this to work you'll have to expose port 4567. If you're using `v3-docker-compose` you can simply modify your `stack.yml`:

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/exercism-local-tooling-webserver.

