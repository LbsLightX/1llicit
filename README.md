<div align="center">

# !-1llicit-!-1llicit-!-1llicit-!

### Termux Bootstrap Framework

> Built upon the foundation of **[LITMux](https://github.com/AvinashReddy3108/LITMux)** by **[AvinashReddy3108](https://github.com/AvinashReddy3108)**. 🛐

**More than a theme.** 1llicit is a complete environment overhaul. It automates Zsh, Powerlevel10k, Nerd Fonts, and custom tools into a single, unified system.

</div>

---

### ✨ Showcase

![Dark Theme 1llicit](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/1llicit-1.jpg)

![Light Theme 1llicit](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/1llicit-2.jpg)

*A unified, aesthetic terminal experience.*

![Font Theme Preview](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/fonts-1.jpg)
![Font Theme Preview](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/fonts-2.jpg)


**＊ Interactive Theme Library (`1ll-colors`)**
*Browse and apply 370+ themes instantly with a live preview.*

![Theme Installer Menu](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/colors-2.gif)

**＊ Nerd Fonts Manager (`1ll-fonts`)**
*Install 2600+ patched fonts without leaving the terminal.*

![Font Manager](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/fonts.gif)

**＊ Powerlevel10k Configuration (`p10k configure`)**
*Effortlessly set up your prompt wizard.*

![P10k Configuration](https://raw.githubusercontent.com/LbsLightX/lbs-archives/main/1llicit/assets/p10k-configure.gif)

---

### ⚠️ CRITICAL WARNING ⚠️

**READ BEFORE INSTALLING:**

1.  **This tool takes control of your `~/.zshrc` file.**
2.  Your existing `.zshrc` will be **automatically backed up** to your internal storage (`~/storage/shared/1llicit/backup/`). It is not deleted.
3.  However, the active `.zshrc` will be replaced by the 1llicit logic.
4. **Do not edit `.zshrc` directly anymore.** Updates will overwrite it.

**Where to put your custom stuff:**
*   Use `~/.zshenv` for environment variables.
*   Use `~/.1llicit/user.zsh` for personal aliases (this file survives updates).
*   Use `~/.bashrc` if you want to keep using Bash separately.

**If you agree to these terms, ✍️ proceed.**

---

### 📥 Requirements

> **⚠️ IMPORTANT:** Do not install Termux from the Google Play Store. It is outdated and unsupported.

#### 📱 Termux App
Install only from official sources:
*   **GitHub:** [Termux](https://github.com/termux/termux-app/releases)
*   **F-Droid:** [Termux](https://f-droid.org/en/packages/com.termux/)


#### 🧩 Termux:API
Required for system integration. Install from the **same source** as the main app:
*   **GitHub:** [Termux:API](https://github.com/termux/termux-api)
*   **F-Droid:** [Termux:API](https://f-droid.org/packages/com.termux.api/)


---

### 📥 Installation

Copy and paste this one-line command into Termux:

```bash
bash -c "$(curl -fsSL https://lbslightx.github.io/1llicit/install.sh)"
```

---

### 🎮 How to Use

Once installed, you have access to the **1ll-** suite of tools. Type them in your terminal to launch.

*   **`1llicit`** 💠 - Show framework status.
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

To revert changes, run this command. It will restore your previous configuration if a backup exists.

```bash
bash -c "$(curl -fsSL https://LbsLightX.github.io/1llicit/uninstall.sh)"
```

---

### 🏆 Acknowledgements

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