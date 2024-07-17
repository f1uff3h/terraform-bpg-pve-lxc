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
