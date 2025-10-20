# ParKing AI Agent Instructions

This guide helps AI agents understand and work effectively with the ParKing codebase.

## Project Overview

ParKing is a Flutter-based application that's in early development. The project aims to provide parking-related services (specific details TBD).

### Tech Stack

- **Frontend**: Flutter
- **Backend**: Under consideration
  - Vercel
  - Better Auth
  - Supabase
  - Firebase

## Project Structure

```
ParKing/
├── .github/          # GitHub configuration and workflows
├── Docs/            # Project documentation
└── [Flutter dirs]   # Standard Flutter project structure (TBD)
```

## Development Guidelines

### Flutter Development

Follow standard Flutter project conventions:
- Separate widgets into reusable components
- Use proper state management (specifics TBD)
- Follow Flutter's style guide and best practices

### Code Quality Standards

We maintain high code quality standards through:

1. **Code Organization**
   - Keep functions small and single-purpose (max 30 lines)
   - Maximum nesting depth of 3 levels
   - Clear and descriptive naming conventions

2. **Testing**
   - Unit tests for new/changed logic
   - Edge case coverage
   - Regression tests for bug fixes

3. **Documentation**
   - Comments explain 'why' not 'what'
   - Public APIs must have docstrings
   - Document complex algorithms

4. **Performance & Security**
   - Review query efficiency
   - Check for memory leaks
   - Proper input validation
   - No hardcoded secrets

## Project Status

This project is in its initial setup phase. Key decisions about backend services and architecture are still being made.

## TODOs and Next Steps

1. Finalize backend service selection
2. Set up initial Flutter project structure
3. Define core features and requirements
4. Establish CI/CD pipeline

Note: These instructions will be updated as the project evolves and more patterns emerge.