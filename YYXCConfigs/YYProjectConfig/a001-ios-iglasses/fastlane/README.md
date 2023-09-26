fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios lint_code
```
fastlane ios lint_code
```
Lint code
### ios format_code
```
fastlane ios format_code
```
Lint and format code
### ios sort_files
```
fastlane ios sort_files
```
Sort Xcode project files
### ios prepare_pr
```
fastlane ios prepare_pr
```
Prepare for a pull request
### ios build_dev_app
```
fastlane ios build_dev_app
```
Build development app
### ios tests
```
fastlane ios tests
```
Run unit tests

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
