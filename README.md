# Custom Conditions Buildkite plugin

Inject steps based on custom conditions defined by you
# Background

The if conditions supported by buildkite do not allow use of runtime derived values, such as a computed value from an earlier step or just a simple conditional switch.

This plugin attempts to provide basic functionality to allow you to conditionally inject steps without having to reinvent the wheel every time.

# Examples:

## Only inject a step, if the git diff has changed compared to an existing saved value.

```yaml

steps:
  - plugins:
      - cultureamp/custom-conditions#v0.1.0:
          condition: git-diff

```

## Custom Condition

```yaml

steps:
  - plugins:
      - cultureamp/custom-conditions#v0.1.0:
          type: custom-script
          script-path: 'path-to-script'

```

## Developing

**Before** opening a pull request, run the tests. You may have to update the tests depending on your proposed change(s).

To run the tests:

```shell
docker-compose run --rm tests
```

You'll also want to run the linter:

```shell
docker-compose run --rm lint
```
