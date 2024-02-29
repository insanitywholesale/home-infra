<h4 align="center">An Ansible role for creating an MOTD banner when logging into yout server.</h4>

<p align="center">
    <a href="https://github.com/totaldebug/ansible-role-deluge/commits/master">
    <img src="https://img.shields.io/github/last-commit/totaldebug/ansible-role-deluge.svg?style=flat-square&logo=github&logoColor=white"
         alt="GitHub last commit">
    <a href="https://github.com/totaldebug/ansible-role-deluge/issues">
    <img src="https://img.shields.io/github/issues-raw/totaldebug/ansible-role-deluge.svg?style=flat-square&logo=github&logoColor=white"
         alt="GitHub issues">
    <a href="https://github.com/totaldebug/ansible-role-deluge/pulls">
    <img src="https://img.shields.io/github/issues-pr-raw/totaldebug/ansible-role-deluge.svg?style=flat-square&logo=github&logoColor=white"
         alt="GitHub pull requests">
</p>

<p align="center">
  <a href="#configuration">Configuration</a> •
  <a href="#features">Features</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#author">Author</a> •
  <a href="#support">Support</a> •
  <a href="#donate">Donate</a> •
  <a href="#license">License</a>
</p>

---

## About

<table>
<tr>
<td>

**ansible-role-deluge** is a **high-quality** _Ansible Role_ that deploys **Deluge 2.x** to your ansible clients.

</td>
</tr>
</table>

## Configuration

### Install

```shell
ansible-galaxy install totaldebug.deluge
```

### Role Variables

#### Deluge

|           **Input**            |               **Default**                |                                 **Description**                                  |
| :----------------------------: | :--------------------------------------: | :------------------------------------------------------------------------------: |
|     `deluge_service_user`      |                 `deluge`                 |                         Username for the service account                         |
|     `deluge_service_group`     |                 `deluge`                 |                          Group for the service account                           |
|         `deluged_port`         |                 `58846`                  |                                   Deluge port                                    |
|         `deluge_home`          |            `/var/lib/deluge`            | Sets the default home for the deluge service account, config will be stored here |
|   `deluge_download_location`   |      `{{ deluge_home }}/downloads`       |                            Downloaded file directory                             |
|  `deluge_move_completed_path`  |    `'{{ deluge_download_location }}'`    |                             Completed downloads path                             |
| `deluge_torrentfiles_location` |    `'{{ deluge_download_location }}'`    |                           Deluge torrent file location                           |
|   `deluge_user_service_dir`    | `/etc/systemd/system/deluged.service.d/` |                  Sets the directory for the user service config                  |
|  `deluge_core_conf_template`   |              `core.conf.j2`              |        allows the use of a custom config file see custom templates below         |
|        `deluge_plugins`        |                                          |                add a list of plugins that you want to be enabled                 |

#### Deluge Web

|           **Input**           |                 **Default**                 |                          **Description**                          |
| :---------------------------: | :-----------------------------------------: | :---------------------------------------------------------------: |
|         `deluge_web`          |                   `true`                    |                 Installs the deluge-web component                 |
|       `deluge_web_port`       |                   `8112`                    |                Change the web port for the portal                 |
| `deluge_web_user_service_dir` | `/etc/systemd/system/deluge-web.service.d/` |          Sets the directory for the user service config           |
|  `deluge_web_conf_template`   |                `web.conf.j2`                | allows the use of a custom config file see custom templates below |

#### Logging

| **Input**          | **Default**        | **Description**  |
| ------------------ | ------------------ | ---------------- |
| `enable_logging`   | `false`            | Enables logging  |
| `deluge_log_dir`   | `/var/log/deluge/` | Log location     |
| `deluge_log_level` | `warning`          | Level of logging |

### Custom Template

The deluge core.conf and web.conf templates packaged with this role are meant to
be very generic. Allowing to set every possible option in there from the
role would be overlly complicated for maintenance.

If the default template does not suit your needs, you can replace it with yours.
What you need to do:

- create a `templates` directory at the same level as your playbook
- create a `templates\mycore.conf.j2` file (just choose a different name from the default template)
- in your playbook set the var `default_web_conf_template: mycore.conf.j2`

### Example Playbook

```yaml
---
- host: all
  roles:
    - totaldebug/deluge
```

## Features

|                           | 🔰  |
| ------------------------- | :-: |
| Install Deluge 2.x        | ✔️  |
| Install Deluge Web        | ✔️  |
| Custom config templates   | ✔️  |
| Setup Log Rotation        | ✔️  |
| Setup Log Level           | ✔️  |
| Configure custom ports    | ✔️  |
| Enable plugins            | ✔️  |
| Ubuntu Support            | ✔️  |
| RedHat / CentOS 8 Support | ✔️  |
| Systemd Services          | ✔️  |

## Contributing

Got **something interesting** you'd like to **share**? Learn about [contributing](https://github.com/totaldebug/.github/blob/main/.github/CONTRIBUTING.md).

### Versioning

This project follows semantic versioning.

In the context of semantic versioning, consider the role contract to be defined by the role variables.

- Breaking Changes or changes that require user intervention will increase the major version. This includes changing the default value of a role variable.
- Changes that do not require user intervention, but add new features, will increase the minor version.
- Bug fixes will increase the patch version.

## Author

| [![TotalDebug](https://totaldebug.uk/assets/images/logo.png)](https://linkedin.com/in/marksie1988) |
| :------------------------------------------------------------------------------------------------: |
|                                   **marksie1988 (Steven Marks)**                                   |

## Support

Reach out to me at one of the following places:

- via [Discord](https://discord.gg/6fmekudc8Q)
- Raise an issue in GitHub

## Donate

Please consider supporting this project by sponsoring, or just donating a little via [our sponsor page](https://github.com/sponsors/marksie1988)

## License

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-orange.svg?style=flat-square)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

- Copyright © [Total Debug](https://totaldebug.uk "Total Debug").
