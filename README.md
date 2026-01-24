<div align="center">

# !-1llicit-!-1llicit-!-1llicit-!
### The Ultimate Termux Bootstrap Framework

> Built upon the foundation of **[LITMux](https://github.com/AvinashReddy3108/LITMux)** by **[AvinashReddy3108](https://github.com/AvinashReddy3108)**. 🛐

**More than a theme.**  
1llicit is a complete environment overhaul. It automates Zsh, Powerlevel10k, Nerd Fonts, and custom tools into a single, unified system.

</div>

---

> A Termux bootstrap framework focused on automation and consistency.

## ✨ Showcase

### Visual Style

*A unified, aesthetic terminal experience.*

![Dark Theme 1llicit](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/1llicit-1.jpg)
![Light Theme 1llicit](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/1llicit-2.jpg)

![Font Theme Preview](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/fonts-1.jpg)
![Font Theme Preview](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/fonts-2.jpg)

### Features in Action

**1. Interactive Theme Library (`1ll-colors`)**
*Browse and apply 370+ themes instantly with a live preview.*

![Theme Installer Menu](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/colors-2.gif)

**2. Nerd Fonts Manager (`1ll-fonts`)**
*Install 2600+ patched fonts without leaving the terminal.*

![Font Manager](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/fonts.gif)

**3. Powerlevel10k Configuration (`p10k configure`)**
*Effortlessly set up your prompt wizard.*

![P10k Configuration](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/p10k-configure.gif)

---

### ⚡ Features - Why It Feels Different

Here is what makes it different:

#### 🧠 Intelligent Prediction.
*   **Ghost Text:** It learns from your history. Start typing a command, and it suggests the rest. Press `→` to accept.
*   **Smart History:** For example, Type `git` and press `UP`. It won't just show the last command; it finds the last time you used `git`.
*   **Syntax Checking:** Commands turn **green** if they work, **red** if they contain typos. (Theme dependent) You know if it's wrong before you even hit Enter.

#### 🎮 Gamified Workflow.
*   **Visual Menus:** Press `TAB` and instead of a boring text list, you get a navigable menu where you can see file details before you select them.
*   **Magic Backspace:** Backspace on an empty line takes you up a directory (`cd ..`). It sounds small, but it quickly becomes indispensable.
*   **Master Grade Keyboard:** A custom 7-key touch bar designed for coding. The **Menu** keys are exactly where your thumbs expect them.

#### 🎨 Industrial Aesthetics.
*   **The Theme & Font Engine:** Swap between **370+** professional color schemes & **2600+** fonts instantly. No restarting required.
*   **Official Fonts:** We use the official **MesloLGS NF** patched for Powerlevel10k / Nerdfonts, so your icons never break.
*   **Heavy Box UI:** Every script follows a strict "industrial" design language. It feels cohesive, not like a bunch of random scripts glued together.

#### 🛡️ Safety Systems.
*   **Snapshot Backups:** Messed up your config? `1ll-backup` saves your entire shell state to a `.tar.gz` file in your Downloads.
*   **Safe Updates:** The updater downloads new code to a temp file first. If your internet cuts out, your shell doesn't break.
*   **Clean Uninstaller:** If you ever want to leave, the uninstaller wipes everything, including installed fonts and color schemes - restoring your Termux to factory settings.

## ⚠️ CRITICAL WARNING 

**READ BEFORE INSTALLING — THIS IS IMPORTANT**

1.  **Automatic Control:** This tool takes full control of your `~/.zshrc` file.
2.  **Safety Backup:** Your existing `.zshrc` is **automatically backed up** to `~/storage/shared/1llicit/backup/` before changes are made.
3.  **Immutable Core:** Do not edit `.zshrc` directly anymore. Updates to 1llicit will overwrite manual changes in that file.

**📍 User Configuration Locations:**
*   Use `~/.zshenv` for environment variables.
*   Use `~/.1llicit/user.zsh` for personal aliases (this file survives updates).
*   Use `~/.bashrc` if you want to keep using Bash separately.

**If you agree to these terms, ✍️ proceed.**

---

### 📥 Requirements

> **⚠️ IMPORTANT:** Do not install Termux from the Google Play Store. It is outdated and unsupported.

#### 📱 Termux App
Install only from the official sources:
*   **GitHub:** [Termux](https://github.com/termux/termux-app/releases)
*   **F-Droid:** [Termux](https://f-droid.org/en/packages/com.termux/)


#### 🧩 Termux:API
Required for system integration. Install from the **same source** as the main app:
*   **GitHub:** [Termux:API](https://github.com/termux/termux-api)
*   **F-Droid:** [Termux:API](https://f-droid.org/packages/com.termux.api/)


---

### 🚀 Installation

Copy and paste this one-line command into Termux:

```bash
bash -c "$(curl -fsSL https://lbslightx.github.io/1llicit/install.sh)"
```

---

### 📘 How to Use

Once installed, you have access to the **1ll-** suite of tools. Type them in your terminal to launch.

*   **`p10k configure`** ⚙️ - Run the Powerlevel10k configuration wizard.
*   **`1ll-colors`** 🎨 - Browse and install 370+ color schemes instantly.
*   **`1ll-fonts`** 🔡 - Install Nerd Fonts without manual downloading.
*   **`1ll-syntax`** 🖋️ - Change your syntax highlighting theme.
*   **`1ll-update`** 🔄 - Update the core framework from the 1llicit GitHub repository.
*   **`1ll-backup`** 💾 - Create a full snapshot of your shell config in Downloads.

---

### 🛠️ Customization

To add your own aliases, functions, or exports that survive updates, create this file:

```bash
touch ~/.1llicit/user.zsh
nano ~/.1llicit/user.zsh
``` 

Anything you write in `user.zsh` is loaded automatically on startup.

---

### 💀 Uninstallation

To revert all changes, run this command. It will restore your previous configuration if a backup exists.

```bash
bash -c "$(curl -fsSL https://LbsLightX.github.io/1llicit/uninstall.sh)"
```

---

## 🏆 Acknowledgements

This project is built on the work of open-source legends.

#### ⚙️ Core Architecture
*   **[Zdharma-Continuum](https://github.com/zdharma-continuum)** - For **[Zinit](https://github.com/zdharma-continuum/zinit)**, the ZSH plugin manager.
*   **[zsh-users](https://github.com/zsh-users)** - For the essential **Autosuggestions**, **Completions**, and **History Search** plugins.
*   **[Romkatv](https://github.com/romkatv)** - For **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** providing the prompt.
*   **[Junegunn](https://github.com/junegunn)** - For **[FZF](https://github.com/junegunn/fzf)** providing the engine behind our interactive menus.

#### 🎨 Visuals & Theming
*   **[Gogh4Termux](https://github.com/AvinashReddy3108/Gogh4Termux)** logic that powers the theme engine.
*   **[Gogh Project](https://github.com/Gogh-Co/Gogh)** - The source of the **370+** color schemes.
*   **[Aloxaf](https://github.com/aloxaf)** - For **[fzf-tab](https://github.com/Aloxaf/fzf-tab)** (visual completion).
*   **[Ryanoasis](https://github.com/ryanoasis)** - For **[Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)**.


<div align="center">

**Maintained with ❤️ by LbsLightX**

</div>