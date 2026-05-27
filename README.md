# Navin (Navigation Intuitive)

**Navin** is a tmux plugin designed to make navigation and pane management completely intuitive. It extends standard tmux functionality with smart, easy-to-remember bindings, acting as a seamless addition to your workflow. Note that it replaced some of tmux's default bindings, but it still intuitive nevertheless.

No more combing through dotfiles for standard layouts or navigation helpers. Navin makes these features "standard."

Thanks to the Tmux community for "inventing" these bindings. I've merely just
copied them here.

Tested and working on Linux, ~~OSX~~ and ~~Cygwin~~.

## Bindings

Notice most of the bindings emulate vim cursor movements.

### **Navigation**

The default way is simply to use the `Alt + arrow` to move around the panes. Can be disabled with:

```
set -g @navin_nav "off"
```

<img align="right" src="/screenshots/pane_navigation.gif" alt="pane navigation"/>

#### **Vim mode (Optional)**

Can be enabled by adding this to you config:

```
set -g @navin_vim_mode_nav "yes"
```

- `prefix + h` and `prefix + C-h`<br/>
  select pane on the left
- `prefix + j` and `prefix + C-j`<br/>
  select pane below the current one
- `prefix + k` and `prefix + C-k`<br/>
  select pane above
- `prefix + l` and `prefix + C-l`<br/>
  select pane on the right

> [!NOTE]
> This overrides tmux's default binding for toggling between last
active windows, `prefix + l`.
> <br>[tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) gives you a better binding for that, `prefix + a` (if your prefix is `C-a`).

<img align="right" src="/screenshots/pane_resizing.gif" alt="pane resizing"/>

#### **Resizing panes**

- `prefix + shift + h`<br/>
  resize current pane 5 cells to the left
- `prefix + shift + j`<br/>
  resize 5 cells in the down direction
- `prefix + shift + k`<br/>
  resize 5 cells in the up direction
- `prefix + shift + l`<br/>
  resize 5 cells to the right

These mappings are **repeatable**.

The amount of cells to resize can be configured with `@navin_pane_resize` option. See. Can be disabled by `@navin_vim_pane_resizing "no"`.
[configuration section](#configuration) for the details.

<br/><br/>

<img align="right" src="/screenshots/pane_splitting.gif" alt="pane splitting"/>

#### **Splitting panes**

- `prefix + |`<br/>
  split the current pane into two, left and right.
- `prefix + -`<br/>
  split the current pane into two, top and bottom.
- `prefix + \`<br/>
  split current pane full width into two, left and right.
- `prefix + _`<br/>
  split current pane full height into two, top and bottom.

Newly created pane always has the same path as the original pane.

> [!NOTE]
> Default delete buffer (clipboard) binding: `prefix + -` moved to `prefix + Del`

#### **Swapping windows**

- `prefix + <` - moves current window one position to the left
- `prefix + >` - moves current window one position to the right

This mappings are **repeatable**.

#### **Adding window**

- `prefix + c` - create new window in front of your current window with your current session path
- `prefix + v` - create and append new window in front of your current window with your current path
- `prefix + N` - create new window at default `base-index` which is `0` by tmux's default

#### **Navigating windows**

- `prefix + Alt + ←` - previous window
- `prefix + Alt + →` - next window
- `prefix + Alt + Home` - first window
- `prefix + Alt + End` - last window

This mappings are **repeatable**. You press `prefix` + hold down `alt` then press the binding.

#### **Browser-style window navigation (No Prefix)**

- `Ctrl + Tab` - next window
- `Ctrl + Shift + Tab` - previous window

> [!IMPORTANT]
> **Terminal Compatibility: Alacritty**
> By default, Alacritty does not send unique sequences for `Ctrl + Tab`. To make this work, add the following to your `alacritty.toml`:

```toml
[[keyboard.bindings]]
key = "Tab"
mods = "Control"
chars = "\u001b[27;5;9~"

[[keyboard.bindings]]
key = "Tab"
mods = "Control|Shift"
chars = "\u001b[6u"
```

#### **Navigating sessions**

- `prefix + Alt + ↑` - previous session
- `prefix + Alt + ↓` - next session

This mappings are **repeatable**.

### **Layout Management**

These bindings allow you to quickly switch between tmux layouts using the `Alt` (Meta) key. This mapping is consistently match the symbols used, with just an addition of modifier key, keeping it intuitive. This mapping can be disabled by option `@navin_layout_nav`.

- `Alt + |` - even horizontal. Just like the symbol it basically says _**make everything looks vertical**_
- `Alt + _` - main horizontal
- `Alt + \` - main vertical
- `Alt + -` - even vertical
- `Alt + =` - tiled. In other words _**make everything equal**_
- `Ctrl + Alt + _` - main horizontal mirrored
- `Ctrl + Alt + \` - main vertical mirrored

## Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

```
set -g @plugin 'lululoid/tmux-pain-control'
```

Hit `prefix + I` to fetch the plugin and source it.

You should now have all `pain-control` bindings defined.

## Manual Installation

Clone the repo:

```
git clone https://github.com/lululoid/tmux-pain-control ~/clone/path
```

Add this line to the bottom of `.tmux.conf`:

```
run-shell ~/clone/path/pain_control.tmux
```

Reload TMUX environment:

```
# type this in terminal
$ tmux source-file ~/.tmux.conf
```

You should now have all `pain-control` bindings defined.

## Configuration

You can set `@navin_pane_resize` Tmux option to choose number of resize cells for the
resize bindings. "5" is the default.

Example:

```
set -g @navin_pane_resize "5"
set -g @navin_nav "yes"
set -g @navin_renumber_windows "on"
set -g @navin_arrow_nav "yes"
set -g @navin_repeat_time "1000"
set -g @navin_vim_pane_resizing "no"
set -g @navin_layout_nav "yes"
```

## Other plugins

You might also find these useful:

- some unimplemented ideas - [ideas.md](ideas.md)
- [sessionist](https://github.com/tmux-plugins/tmux-sessionist) - lightweight
  tmux utils for switching and creating sessions
- [logging](https://github.com/tmux-plugins/tmux-logging) - easy logging and
  screen capturing

## License

[MIT](LICENSE.md)
