# CLAUDE.md

> Project instructions for AI assistants working on activerecord-null gem

## Agent OS Documentation

### Product Context
- **Mission & Vision:** @.agent-os/product/mission.md
- **Technical Architecture:** @.agent-os/product/tech-stack.md
- **Development Roadmap:** @.agent-os/product/roadmap.md
- **Decision History:** @.agent-os/product/decisions.md

### Development Standards
- **Code Style:** @~/.agent-os/standards/code-style.md
- **Best Practices:** @~/.agent-os/standards/best-practices.md

### Project Management
- **Active Specs:** @.agent-os/specs/
- **Spec Planning:** Use `@~/.agent-os/instructions/create-spec.md`
- **Tasks Execution:** Use `@~/.agent-os/instructions/execute-tasks.md`

## Workflow Instructions

When asked to work on this codebase:

1. **First**, check @.agent-os/product/roadmap.md for current priorities
2. **Then**, follow the appropriate instruction file:
   - For new features: @~/.agent-os/instructions/create-spec.md
   - For tasks execution: @~/.agent-os/instructions/execute-tasks.md
3. **Always**, adhere to the standards in the files listed above

## Important Notes

- Product-specific files in `.agent-os/product/` override any global standards
- User's specific instructions override (or amend) instructions found in `.agent-os/specs/...`
- Always adhere to established patterns, code style, and best practices documented above

## Project-Specific Guidelines

### This is a Ruby Gem Library

This is NOT a Rails application - it's a library gem that extends ActiveRecord. Keep this context in mind:

- No application hosting, database hosting, or asset hosting
- Focus is on library code quality, API design, and compatibility
- Tests use SQLite3 in-memory database
- Must maintain backward compatibility within major versions

### Code Style Enforcement

Before committing, ALWAYS run:
```bash
bundle exec standardrb --fix
```

All code must pass Standard linting. No exceptions.

### Testing Requirements

- Use Minitest (not RSpec)
- All new features must have comprehensive test coverage
- Run tests with: `rake test` (default rake task)
- Tests are in `test/` directory following Minitest conventions

### Release Process

This gem uses Reissue for release management:

1. Use git trailers for changelog entries in commits
2. Run `rake build:checksum` to build gem and generate checksums
3. Run `rake release` to create git tag, push commits/tags, and push to RubyGems
4. Reissue automatically increments version and updates changelog

**Never manually edit:**
- `lib/activerecord/null/version.rb` (managed by Reissue)
- `CHANGELOG.md` (generated from git trailers)

### ActiveRecord Compatibility

- Minimum ActiveRecord version: 7.0
- Minimum Ruby version: 3.0.0
- Test against multiple ActiveRecord versions if adding complex features
- Be mindful of ActiveRecord's reflection API and association internals

### Design Philosophy

From @.agent-os/product/decisions.md:

1. **Drop-in Replacement:** Null objects should work anywhere real records work
2. **Singleton Pattern:** One null object instance per model class
3. **Zero Configuration:** Associations and attributes work automatically
4. **Simple API:** Creating null objects should be easy and obvious

### Current Phase

Per @.agent-os/product/roadmap.md, we are in **Phase 1: Edge Case Exploration**

Focus areas:
- Finding and fixing edge cases
- Testing complex association scenarios
- Ensuring production-ready stability
- Documenting limitations and known issues

When proposing new features, consider whether they:
1. Fix an edge case or bug
2. Improve compatibility with Rails ecosystem
3. Maintain API simplicity
4. Are backwards compatible
