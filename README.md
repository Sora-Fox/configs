# Dotfiles Repository

This repository contains my personal configuration files for various tools and applications, such as `zsh`, `nvim`, `alacritty`, `qutebrowser`, and more. These configurations are designed to customize and optimize development and work environment.

---

##  How to Use

### 1. Clone the Repository
Clone this repository to your local machine:
```bash
git clone https://github.com/Sora-Fox/dotfiles.git 
cd dotfiles
```

### 2. Install Configurations
To install all available configuration files, use the `configurator.sh` script. This script will automatically copy or symlink the configuration files to their appropriate locations.

#### Usage:
- **Install all configurations**:
```bash
  ./configurator.sh --copy
```
  This command copies the configuration files to the target locations.
  You can use `--symlink`to creates symbolic links to the configuration files in the target locations instead of copying files.

- **Remove target files**:
```bash
  ./configurator.sh --remove
```

- **Help**:
```bash
  ./configurator.sh --help
```

#### Important Note:
The script installs **all available configurations** by default.  
If you only need specific configurations, you can manually copy them to the desired locations. Use the `--help` option to see the list of files and their target paths.

---

## Screenshots


---

##  License

This project is licensed under the **GNU General Public License v3.0**.  
For more details, see the [LICENSE](./LICENSE) file.

