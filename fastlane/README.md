fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios add_device

```sh
[bundle exec] fastlane ios add_device
```



### ios sync_profiles

```sh
[bundle exec] fastlane ios sync_profiles
```

Fetches certificates and profiles from the ios-certificates repository by HTTPS

### ios test

```sh
[bundle exec] fastlane ios test
```

Runs all the tests

### ios increase_build_version

```sh
[bundle exec] fastlane ios increase_build_version
```



### ios deploy_dev

```sh
[bundle exec] fastlane ios deploy_dev
```



### ios deploy_prod

```sh
[bundle exec] fastlane ios deploy_prod
```



### ios upload_dsyms

```sh
[bundle exec] fastlane ios upload_dsyms
```

upload dsyms to Sentry service

### ios connect_to_app_store

```sh
[bundle exec] fastlane ios connect_to_app_store
```

Get App Store Connect api key using env variables

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
