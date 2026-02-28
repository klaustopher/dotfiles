# Global Claude Instructions

## About me

Senior software developer. Skip introductory explanations of standard tools, patterns, and concepts. Assume familiarity with the full stack — Ruby, Rails, React, TypeScript, Docker, Unix. High-level technical conversations are preferred.

## Environment

- Primary machine: macOS with Homebrew
- Secondary: Arch Linux with paru
- Shell: zsh
- Editors: VSCode, Neovim

## Package management

- macOS: Homebrew (`brew`)
- Arch Linux: paru (wraps pacman + AUR)
- Don't default to `apt` unless the context is explicitly Debian/Ubuntu

## Cross-platform awareness

When writing anything that touches the system (paths, packages, services, users/groups), consider whether it works on both macOS and Arch Linux unless the context is clearly platform-specific. Especially when working on the dotfiles.

## Primary tech stack

- **Backend**: Ruby on Rails, Crystal, Go, PostgreSQL
- **Frontend**: React, TypeScript
- **Testing**: RSpec
- **Infrastructure**: Git, Docker

## Ruby / Rails conventions

- Dry::Validations and other `dry-rb` gems only when they make sense for the problem domain; otherwise, plain Ruby/Rails conventions
- Don't create generic `Constants` modules — constants belong semantically with the code that uses them
- Follow domain-driven organisation: code structure should reflect business logic, not generic file types
- RSpec for testing — tests are part of the implementation, not an afterthought
- Use rubocop to format code. Most projects will use [my own rubocop config](https://github.com/klaustopher/rubocop-config), but if not, follow the project's existing style

## React / TypeScript conventions

- Prefer global state management over prop-drilling through multiple levels
- Local state is fine for simple, isolated components — don't over-engineer

## Frontend

- When our project uses a component library,
  - follow its conventions and patterns closely rather than trying to reinvent the wheel
  - do not write custom CSS for styling if the component library provides a way to customize styles through props or theming
  - avoid writing custom CSS unless absolutely necessary; leverage the component library's styling system as much as possible
- Most likely frontend libraries will be:
  - [Tabler](https://tabler.io/)
  - [Ant Design](https://ant.design/)

## General code principles

- Prefer simple solutions over clever abstractions; don't build things that aren't needed yet
- A little duplication is fine if it keeps things straightforward and avoids premature abstraction
- Focus on readability and maintainability over micro-optimizations or "clever" code
- When in doubt, choose the option that will be easier for another developer to understand and work with in the future, even if it means writing a bit more code or being more explicit

## Workflow

- Discuss architecture and approach before writing code
- When asked to look at existing code, give an honest opinion on what could be improved — don't just describe what's there
- Iterate: propose, get feedback, refine

## Communication

- Concise responses with concrete trade-offs over exhaustive option lists
- Recommend one approach and explain why, rather than listing everything equally
