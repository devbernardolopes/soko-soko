# AGENTS.md

This is a simple 2D sokoban-like game being developed in Godot 4.

## Requirements

- Godot 4.7 using GDScript and following Godot's own code style guidelines.

## Testing

All **gameplay** testing is manual by the human after every iteration: do not run the main game scene.
The testing device is:

1. Samsung Odyssey laptop running Omarchy Quattro in 1920 x 1080 @ 60 Hz.

## Agent Workflow Notes

- Godot 4 API differs from Godot 3. When unsure about a property or method, check the Godot 4.7 docs instead of guessing.
- Avoid local variables or parameters that shadow existing member variables (GDScript warns on shadowing). If a local/parameter name would collide with a member (e.g. a method parameter named `scale` when the class is a Node2D that already has `scale` ), rename the local/parameter with a `_` prefix (e.g. `_scale`).
- Don't bother reading the contents of `res://addons` because they're just third-party plug-ins and their code isn't relevant to this development.

## Commit Convention

When there are changes to commit, AI agents should suggest an one-line commit message at the end of their response following conventional commit format: `type(scope): description`. Use types like `feat`, `fix`, `refactor`, `docs`, `chore` and keep descriptions concise but descriptive — focus on the "why" rather than the "what". This message must be in own line to facilitate copying.
