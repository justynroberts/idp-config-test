# Skeletons

Each folder here is a starting point for a new repository, used by the `template/render` step.
File and folder names may contain `{{ values.name }}` and friends; files ending in `.tmpl` are
rendered and lose the suffix. Everything else is copied as it is, so CI files keep their
`${{ github.sha }}` expressions. The portal does not read this folder as config.
