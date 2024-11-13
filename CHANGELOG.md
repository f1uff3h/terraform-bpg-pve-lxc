# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1] - 2024-07-17

### Removed

- Removed `ct-root-pw` variable from `variables.tf` and its usage in `main.tf` and `README.md`.

### Changed

- Updated `ct-start` variable in `variables.tf` and `README.md` to include `order`, `up-delay`, and `down-delay` fields.
- Updated `ct-root-pw` usage in `main.tf` to use `ct-init.root_pw`.

## [0.2.2] - 2024-07-17

### Changed

- Fixed root password field in `main.tf` to work when `random_password` is not created.

## [0.2.3] - 2024-11-04

### Added

- `ct-protection` variable to allow for setting of protection mode

### Changed

- updated min required provider version

## [0.2.4] - 2024-11-09

### Fixed

- fixed bug in firewall option where firewall options would not be applied if set and would be applied if unset

## [0.3.0] - 2024-11-11

### Changed

- **BREAKING**: all variables now conform to HCL canonical form

### Updated

- Added precondition to `bootstrap_ct` to check for ssh private key presence

## [0.3.1] - 2024-11-13

### Added

- Test

### Changed

- Bumped minimum required terraform version to >=1.9
- Split container OS precondition into more granular ones
- added more bootstrap preconditions to avoid failures

### Fixed

- reference to undeclared variables due to HCL canonical form update
