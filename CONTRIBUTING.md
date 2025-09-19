# Contributing to SatelliteAPI

Thank you for considering contributing to SatelliteAPI! This document outlines the process for contributing to this project.

## Code of Conduct

By participating in this project, you agree to abide by the [Ruby Community Conduct Guideline](https://www.ruby-lang.org/en/conduct/).

## How to Contribute

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
   ```bash
   git clone git@github.com:your-username/ruby-satelliteapi.git
   cd ruby-satelliteapi
   ```
3. **Create a branch** for your feature or bug fix
   ```bash
   git checkout -b my-new-feature
   ```
4. **Write tests** for your changes
5. **Implement** your feature or bug fix
6. **Run the tests** to ensure they pass
   ```bash
   bundle exec rspec
   ```
7. **Run RuboCop** to ensure your code meets style guidelines
   ```bash
   bundle exec rubocop
   ```
8. **Commit your changes** with a meaningful commit message
   ```bash
   git commit -am 'Add some feature'
   ```
9. **Push to your branch**
   ```bash
   git push origin my-new-feature
   ```
10. **Create a new Pull Request** through the GitHub interface

## Development Setup

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Testing

Please make sure your changes include tests that cover your code. Run the tests with:

```bash
bundle exec rspec
```

## Code Style

Follow the Ruby style guide and use RuboCop to check your code:

```bash
bundle exec rubocop
```

## Release Process

To release a new version:

1. Update the version number in `lib/satelliteapi/version.rb`
2. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Questions?

Feel free to open an issue if you have any questions about contributing.