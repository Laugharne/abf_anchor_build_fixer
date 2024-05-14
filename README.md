
# Anchor Build fixer

![](assets/pexels-tara-winstead-7722845.jpg)
(*[Tara Winstead - Pexels](https://www.pexels.com/@tara-winstead/)*)

--------

<!-- TOC -->

- [Anchor Build fixer](#anchor-build-fixer)
	- [🔭 Overview](#-overview)
	- [🕑 Current versions](#-current-versions)
	- [📦 Installation](#-installation)
	- [🚀 How to run](#-how-to-run)
		- [💻 Usage](#-usage)
		- [✏️ Commands](#-commands)
	- [📚 Additional resources](#-additional-resources)

<!-- /TOC -->

--------

## 🔭 Overview

The **first build** with Anchor can be challenging, especially for those who are not familiar with Rust compilations and Anchor environnement.

This script (`"abf.sh"`) which overlays **Anchor** calls (*cli commands*), tries to dynamicaly fix the build issues you are most likely to encounter as best as it can.

It defines several functions in **Bash** to handle building and fixing errors in an **Anchor project**. It includes color-coded output and error handling. Each function is documented with comments to explain its purpose and usage.

> This project is currently a **work in progress** and may not be ready for production use !


## 🕑 Current versions

I actually build **Anchor projects** with the following versions of OS and tools:

| Tools      | Versions                    |
| ---------- | --------------------------- |
| **OS**     | `Ubuntu 22.04.2 LTS x86_64` |
| **rustc**  | `1.77.1`                    |
| **cargo**  | `1.77.1`                    |
| **solana** | `1.17.4`                    |
| **node**   | `18.16.0`                   |
| **anchor** | `0.29.0`                    |


## 📦 Installation

- **bash**: `cat abf.sh >> ~/.bashrc` or `cat abf.sh >> ~/.bash_functions`
- **zsh**: `cat alias.sh >> ~/.zshrc`

## 🚀 How to run

Go into your projects directory, then type `abf init <PROJECT_NAME>` to create project sub-directory `<PROJECT_NAME>`.


### 💻 Usage

`abf <command> <OPTIONAL_PARAMETER>`


### ✏️ Commands

| Command      | Description             | Parameter              |
| :----------- | :---------------------- | :--------------------- |
| `init`, `i`  | Initializes a workspace | `<PROJECT_NAME>` *(1)* |
| `build`, `b` | Build a workspace       | none                   |
| `version`    | Print 'abf' version     | none                   |
| `versions`   | Print assets versions   | none                   |
| `help`       | Print help message      | none                   |

- *(1) : mandatory*


## 📚 Additional resources

- [Solana Hello World (Installation and Troubleshooting)](https://www.rareskills.io/post/hello-world-solana)
- [anchor build isn't working properly - Solana Stack Exchange](https://solana.stackexchange.com/questions/2770/anchor-build-isnt-working-properly)
- [solana - Anchor build failure - Stack Overflow](https://stackoverflow.com/questions/73360283/anchor-build-failure)
- [anchor build failed - Solana Stack Exchange](https://solana.stackexchange.com/questions/6853/anchor-build-failed)
- [cargo - Anchor Build Depenedency error - Solana Stack Exchange](https://solana.stackexchange.com/questions/670/anchor-build-depenedency-error?rq=1)
