# Nix Templates

My personal collection of development templates which are opinionated and
tailored to my tastes. But if you happen to find and error or have an idea how a
template can be improved feel free to open a PR (I can't guarantee any merges of
course).

## Available templates

### ⭐ Gleam

A template for the functional programming language Gleam running on the BEAM
virtual machine.

<details>
<summary>🐚 Init Commands</summary>
<br>

**Codeberg**:

```sh
nix flake init -t git+https://codeberg.org/ginkogruen/nix-templates.git#gleam
```

**GitHub**:

```sh
nix flake init -t github:ginkogruen/nix-templates#gleam
```

</details>

### 🦋 Lustre

A template for working with the Lustre web framework bases on the Gleam
programming language.

<details>
<summary>🐚 Init Commands</summary>
<br>

**Codeberg**:

```sh
nix flake init -t git+https://codeberg.org/ginkogruen/nix-templates.git#lustre
```

**GitHub**:

```sh
nix flake init -t github:ginkogruen/nix-templates#lustre
```

</details>

### 🦀 Rust

A template for the systems programming language Rust.

<details>
<summary>🐚 Init Commands</summary>
<br>

**Codeberg**:

```sh
nix flake init -t git+https://codeberg.org/ginkogruen/nix-templates.git#rust
```

**GitHub**:

```sh
nix flake init -t github:ginkogruen/nix-templates#rust
```

</details>

### 🧪 SuperCollider

A template for the music programming language SuperCollider.

<details>
<summary>⚙️ Setup Instructions</summary>

To setup a new SuperCollider project create a file with the extension `.sc` /
`.scd`.

Start the IDE with `scide` and the language CLI with `sclang`. There is also a
neovim package in path with the `scnvim` plugin installed.

</details>

<details>
<summary>🐚 Init Commands</summary>
<br>

**Codeberg**:

```sh
nix flake init -t git+https://codeberg.org/ginkogruen/nix-templates.git#supercollider
```

**GitHub**:

```sh
nix flake init -t github:ginkogruen/nix-templates#supercollider
```

</details>
