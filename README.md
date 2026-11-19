# Outpost

Outpost is a workspace for development teams.
It brings projects and their tasks together in one place
to make organizing work and collaborating easier.

## Outpost Core

This repository shares selected parts of Outpost's source code, built with
Ruby on Rails. It offers practical examples to explore the project's
foundations.

It includes:

- The `Project` and `Task` models and their association.
- The organization domain: `Organization`, `OrganizationMembership`
  (owner / admin / member roles), `Team` and `Invitation`.
- Git activity tracking: the `Activity` and `WebhookEvent` models and the
  `WebhookProcessor` service that verifies GitHub/GitLab webhook signatures.
- The database schema (`db/schema.rb`) describing tables and constraints.
- Helpers for projects and tasks.
- Model test files as starting points to build on.
- The Ruby version and RuboCop configuration used by the project.

## Learning from the code

The published code demonstrates how Rails represents the relationship
between a project and its tasks using Active Record, and how deleting
a project also deletes its tasks.

## Scope

Outpost Core is an excerpt from the project, not a standalone application.
The web interface, authentication, and configuration required to run
the website are not included.

Files are synchronized from Outpost's main repository.
