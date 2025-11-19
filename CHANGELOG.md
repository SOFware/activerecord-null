# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.5] - 2025-11-19

### Added

- Void() method for defining non-singleton null objects (0e89194)
- Model.void(attributes) for creating instances with attribute overrides (0e89194)

### Changed

- Mimic module now delegates table_name to parent model (c6f3956)
- Extracted create_null_class, setup_singleton_attributes, setup_instance_attributes helpers (b0a77f8)
- Pass class_name to the Null() or Void() methods with an alternative class name. (d3284c4)

## [0.1.5] - 2025-11-19

### Added

- Void() method for defining non-singleton null objects (0e89194)
- Model.void(attributes) for creating instances with attribute overrides (0e89194)

### Changed

- Mimic module now delegates table_name to parent model (c6f3956)
- Extracted create_null_class, setup_singleton_attributes, setup_instance_attributes helpers (b0a77f8)
- Pass class_name to the Null() or Void() methods with an alternative class name. (d3284c4)
