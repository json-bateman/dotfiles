# Project Development Guidelines

## Code Quality Principles

- **Always follow Best Practice, Clean Code Principles, and SOLID Principles**
- **Keep the codebase very clean and organized**
- **Avoid duplication of code whenever possible**
  - Check for other areas of the codebase that might already have similar code and functionality
  - Reuse existing implementations before creating new ones

## Code Modification Guidelines

- **Always look for existing code to iterate on instead of creating new code**
- **Do not drastically change patterns before trying to iterate on existing patterns**
- **Avoid making major changes to patterns and architecture** after features have shown to work well, unless explicitly instructed
- **When fixing an issue or bug:**
  - Exhaust all options for the existing implementation first
  - Do not introduce new patterns or technologies without necessity
  - If you do introduce a new pattern, remove the old implementation to avoid duplicate logic
- **AVOID MONKEY PATCHING**

## Scope & Focus

- **Be careful to only make changes that are requested** or you are confident are well understood and related to the change being requested
- **Focus on the areas of code relevant to the task**
- **Do not touch code that is unrelated to the task**
- **Always think about what other methods and areas of code might be affected by code changes**

## Environment & Configuration

- **Write code that takes into account different environments:** dev, test, and prod
- **Never overwrite the `.env` file without first asking and confirming**
- **Avoid writing scripts in files if possible**

## Testing & Data

- **Write thorough tests for all major functionality**
- **Mocking data is only needed for tests**
  - Never mock data for dev or prod
  - Never add stubbing or fake data patterns to code that affects dev or prod environments
