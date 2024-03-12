
# Anchor Build fixer

![](assets/pexels-tara-winstead-7722845.jpg)

## Table of Content

<!-- TOC -->

- [Anchor Build fixer](#anchor-build-fixer)
	- [Table of Content](#table-of-content)
	- [Introduction](#introduction)
	- [Current versions](#current-versions)
	- [Installation](#installation)
		- [bash](#bash)
		- [zsh](#zsh)
	- [Additional resources](#additional-resources)

<!-- /TOC -->

## Introduction

The **first build** with Anchor can be challenging, especially for those who are not familiar with Rust compilations and Anchor environnement.

This script, which overlays **Anchor** calls (*cli commands*), tries to automaticaly fix the build issues you are most likely to encounter as best as it can.


## Current versions

I actually build **Anchor projects** with the following versions:
- **rustc** : `1.76.0`
- **cargo** : `1.76.0`
- **solana** : `1.17.4`
- **node** : `18.16.0`
- **anchor** : `0.29.0`


## Installation

### bash
`cat abf.sh >> ~/.bashrc` or `cat abf.sh >> ~/.bash_function`

### zsh
`cat alias.sh >> ~/.zshrc`


## Additional resources

- [Solana Hello World (Installation and Troubleshooting)](https://www.rareskills.io/post/hello-world-solana)
- [anchor build isn't working properly - Solana Stack Exchange](https://solana.stackexchange.com/questions/2770/anchor-build-isnt-working-properly)
- [solana - Anchor build failure - Stack Overflow](https://stackoverflow.com/questions/73360283/anchor-build-failure)
- [anchor build failed - Solana Stack Exchange](https://solana.stackexchange.com/questions/6853/anchor-build-failed)
----
- [bash - Replace one substring for another string in shell script - Stack Overflow](https://stackoverflow.com/questions/13210880/replace-one-substring-for-another-string-in-shell-script)
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)
- [Returning Values from Functions in Bash Shell Scripting](https://ioflood.com/blog/bash-function-return-value/)
- [Bash until Loop](https://linuxize.com/post/bash-until-loop/)
- [bash - How to change the output color of echo in Linux - Stack Overflow](https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux)
