# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - Unreleased

## [0.1.1] - 2024-10-25

### Added

- `null?` method to both parent class objects and null objects
- Null objects now have default nil values for attributes of the mimic model class
- `Null()` method can now accept a hash of attribute names and values to assign to the null object
- `has_query_constraints?` method to null objects
- `respond_to?` method to null objects
- `_read_attribute` method to null objects
- Null class now return false for `composite_primary_key?`
