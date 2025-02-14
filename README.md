# multi-vpn-manager
# VPN Connection Script

This script allows you to connect to different VPNs using various methods such as Fortinet, AnyConnect, and OpenFortiVPN. It simplifies the process of managing multiple VPN profiles and connecting to them with ease.

## Features

- **Multiple VPN Profiles**: Store and manage multiple VPN configurations.
- **Support for Different Protocols**: Works with AnyConnect, OpenFortiVPN, and other protocols.
- **Easy to Use**: Simple command-line interface to select and connect to a VPN.

## Prerequisites

- **openconnect**: Required for AnyConnect VPNs.
- **openfortivpn**: Required for Fortinet VPNs.
- **bash**: The script is written in Bash, so a Bash shell is required.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/smasoudrezvani/multi-vpn-manager.git
   cd multi-vpn-manager
2. **Make the script executable**:
   ```bash
   chmod +x connect_vpn.sh
   ```

3. **Install required packages**:
   - For AnyConnect:
     ```bash
     sudo apt update
     sudo apt install openconnect
     ```
   - For OpenFortiVPN:
     ```bash
     sudo apt update
     sudo apt install openfortivpn
     ```

## Usage

### 1. Create VPN Profiles

Create a directory to store your VPN profiles:
```bash
mkdir -p ~/.vpn_profiles
```

Create a configuration file for each VPN profile. For example, to create a profile for a home VPN:
```bash
nano ~/.vpn_profiles/homevpn.conf
```

Add the following content to the file:
```
host=vpn.home.com
port=443
user=homeuser
password=homepassword
protocol=anyconnect
```

Repeat this process for each VPN you want to configure.

### 2. Secure the Config Files

Ensure that your VPN configuration files are secure:
```bash
chmod 600 ~/.vpn_profiles/*.conf
```

### 3. Connect to a VPN

Run the script to connect to a VPN:
```bash
./connect_vpn.sh
```

The script will list all available VPN profiles. Enter the name of the VPN you want to connect to, and the script will handle the rest.

## Example

### Connecting to a VPN

1. **List available VPN profiles**:
   ```bash
   ./connect_vpn.sh
   ```

   Output:
   ```
   Available VPN Profiles:
   homevpn
   officevpn
   ```

2. **Select a VPN profile**:
   ```
   Enter the VPN name to connect: homevpn
   ```

3. **The script will connect to the VPN**:
   ```
   Connecting using openconnect...
   ```

## Troubleshooting

- **VPN profile not found**: Ensure that the VPN profile name is correct and that the configuration file exists in `~/.vpn_profiles/`.
- **Missing dependencies**: Ensure that `openconnect` or `openfortivpn` is installed depending on the protocol you are using.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
```
