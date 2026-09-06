# Script Management

## Source of Truth

* **Location:** `~/dotfiles/scripts/`
* Every executable utility lives directly inside the Git repository.
* No symlinks are required. Scripts are stored directly in the repository, making the repository the source of truth for their contents.

## Execution Routing

| Environment                     | How It Finds Scripts                          | Configuration File                     |
| ------------------------------- | --------------------------------------------- | -------------------------------------- |
| **Interactive Terminal (Bash)** | Via `$PATH` (`~/dotfiles/scripts`)            | `~/.bashrc`                            |
| **System Services & Daemons**   | Via `$PATH` on session startup                | `~/.config/environment.d/10-path.conf` |
| **Hyprland Keybindings**        | Direct absolute path (`scripts .. "name.sh"`) | `~/.config/hypr/keybindings.lua`       |

## Rules for Adding New Scripts

1. Drop the script directly into:

   `~/dotfiles/scripts/<script-name>.sh`

2. Grant execution rights:

   ```bash
   chmod +x ~/dotfiles/scripts/<script-name>.sh
   ```

3. Use it immediately:

   **From terminal:**

   ```bash
   <script-name>.sh
   ```

   **From Hyprland:**

   ```lua
   hl.dsp.exec_cmd(scripts .. "<script-name>.sh")
   ```

4. Stage and commit the changes from the dotfiles repository:

   ```bash
   cd ~/dotfiles
   git add scripts/<script-name>.sh
   git commit -m "Add <script-name> utility"
   ```

