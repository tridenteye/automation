# RHEL 9 VNC Setup Script

This script automates the setup of a Red Hat Enterprise Linux 9 (RHEL 9) system with a GUI, xRDP, and necessary configurations. It includes error handling and logging to ensure a smooth installation process.

## Features

- Checks if the operating system is RHEL 9.
- Installs the "Server with GUI" group.
- Configures the system to use graphical targets by default.
- Enables the CodeReady Builder repository.
- Adds the EPEL repository.
- Installs xRDP, TigerVNC server, and xterm.
- Enables and starts xRDP services.
- Opens the necessary port (3389) in the firewall if the firewall is active.
- Configures the system to use the GNOME session.

## Prerequisites

- You must have root or sudo privileges to run this script.
- The system must be running Red Hat Enterprise Linux 9.

## Usage

1. Download or clone this repository.
2. Make the script executable:
    ```sh
    chmod +x vnc.sh
    ```
3. Run the script:
    ```sh
    sudo ./vnc.sh
    ```

The script logs all output to `/var/log/setup_rhel9.log` for easy debugging and tracking.

## Logging

All script actions and outputs are logged to `/var/log/setup_rhel9.log`. If any errors occur, the script will log the error and the line number where the error occurred, then exit.

## Example Output

```
Script started at Fri Jul 17 14:20:31 UTC 2024
Running script on RHEL 9
Installing Desktop environment...
Setting graphical targets...
Enabling CodeReady Builder repository...
Adding EPEL repository...
Installing xRDP and necessary packages...
Enabling and starting xRDP services...
Checking firewall status...
Firewall is active. Adding port 3389...
Enabling GNOME session...
Script completed at Fri Jul 17 14:25:42 UTC 2024
```

## Troubleshooting

- **Firewall Issues**: Ensure that the firewall is enabled and active if you want to add port 3389.
- **Package Installation Failures**: Verify network connectivity and repository availability.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
