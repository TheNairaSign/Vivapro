---
trigger: always_on
---

# Antigravity Agent Rules

## Language & Platform
- Primary language is Dart
- Framework is Flutter
- Prefer null-safe Dart
- Target Flutter 3.x+

## Architecture
- Use feature-first
- No business logic in widgets
- Repositories must return Either<Failure, T>

## State Management
- Prefer Riverpod (latest stable)
- Use BLoC for large and scalable projects
- Avoid legacy providers
- No setState for non-trivial logic

## UI Rules
- Respect Material 3
- Support light and dark themes
- Avoid hardcoded colors
- Use Theme.of(context)

## Code Quality
- Avoid unnecessary abstractions
- Prefer composition over inheritance
- Keep widgets small and reusable
- Max widget build method: 50 lines

## What NOT to do
- Do not introduce new packages without explanation
- Do not change public APIs unless explicitly asked
- Do not generate mock data unless requested

## Output Style
- Explain reasoning briefly before code
- Always include complete, compilable Dart code
- Prefer examples over theory