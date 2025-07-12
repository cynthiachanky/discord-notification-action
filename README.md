# Discord Notification Action

[![Release](https://img.shields.io/github/v/release/cynthiachanky/discord-notification-action?style=for-the-badge)](https://github.com/cynthiachanky/discord-notification-action/releases)
[![Unit Test (Release)](https://img.shields.io/github/actions/workflow/status/cynthiachanky/discord-notification-action/unit-test-release.yml?style=for-the-badge&label=Unit%20Test%20(Release))](https://github.com/cynthiachanky/discord-notification-action/actions?workflow=Unit%20Test%20(Release))
[![GitHub License](https://img.shields.io/github/license/cynthiachanky/discord-notification-action?style=for-the-badge)](LICENSE)

Automatically post release notes to a Discord channel.

![Default Profile](assets/profile/default.png)

**Table of Contents**
<!-- TOC -->
* [Discord Notification Action](#discord-notification-action)
  * [Usage](#usage)
    * [Predefined Profile](#predefined-profile)
      * [Post a release note on behalf of GitHub Actions](#post-a-release-note-on-behalf-of-github-actions)
      * [Post a release note on behalf of Author](#post-a-release-note-on-behalf-of-author)
    * [Custom Profile](#custom-profile)
  * [Example](#example)
    * [Post the release note to a Discord channel when a release is published](#post-the-release-note-to-a-discord-channel-when-a-release-is-published)
  * [Documentation](#documentation)
    * [Inputs](#inputs)
    * [Outputs](#outputs)
    * [Notes](#notes)
  * [License](#license)
<!-- TOC -->

## Usage

```yaml
      - uses: cynthiachanky/discord-notification-action@v1
        with:
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
```

> [!IMPORTANT]
> You have to specify `read` access for `contents` permission either at
> the [workflow](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#permissions) level or
> at
> the [job](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idpermissions) level
> in order to use the action.

### Predefined Profile

The action provides **GitHub Actions** and **Author** as predefined profiles. You can use any of them by setting
`post_as`:

#### Post a release note on behalf of GitHub Actions

```yaml
      - uses: cynthiachanky/discord-notification-action@v1
        with:
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          post_as: "action"
```

![Action Profile](assets/profile/action.png)

#### Post a release note on behalf of Author

```yaml
      - uses: cynthiachanky/discord-notification-action@v1
        with:
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          post_as: "author"
```

![Author Profile](assets/profile/author.png)

### Custom Profile

Alternatively, you can customize the name and/or avatar of the Webhook by providing `webhook_name` and/or
`webhook_avatar`:

```yaml
      - uses: cynthiachanky/discord-notification-action@v1
        with:
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
          webhook_name: "GitHub Webhook"
          webhook_avatar: "https://raw.githubusercontent.com/cynthiachanky/discord-notification-action/main/assets/webhook.png"
```

![Custom Profile](assets/profile/custom.png)

## Example

### Post the release note to a Discord channel when a release is published

```yaml
name: Release Workflow

on:
  release:
    types: [ published ]

jobs:
  notify:
    permissions:
      contents: read
    runs-on: ubuntu-latest
    steps:
      - name: Post the release note to Discord
        uses: cynthiachanky/discord-notification-action@v1
        with:
          webhook_url: ${{ secrets.DISCORD_WEBHOOK_URL }}
```

## Documentation

See [action.yml](action.yml) for the full documentation.

### Inputs

| Name             | Description                                                         | Required | Default |
|------------------|---------------------------------------------------------------------|----------|---------|
| `webhook_url`    | The URL used for executing the Webhook                              | `true`   |         |
| `webhook_name`   | The name of the Webhook                                             | `false`  |         |
| `webhook_avatar` | The avatar of the Webhook                                           | `false`  |         |
| `post_as`        | The profile of the Webhook (Options: `default`, `action`, `author`) | `false`  | default |

### Outputs

| Name           | Description                          |
|----------------|--------------------------------------|
| `release_id`   | The unique identifier of the release |
| `release_name` | The name of the release              |
| `release_url`  | The URL of the release               |

### Notes

1. Setting `post_as` to `action` or `author` will override the values of `webhook_name` and `webhook_avatar`.
2. The action will not be run unless the workflow using the action is triggered by a `release` event.
3. If a workflow uses `GITHUB_TOKEN` or `github.token` to perform a release event, the workflow using the action cannot
   be triggered. For more information,
   see [Triggering a workflow from a workflow](https://docs.github.com/en/actions/how-tos/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow#triggering-a-workflow-from-a-workflow).

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
