# aws-instance-connect-zsh

A Zsh plugin for quickly connecting to AWS EC2 instances using [EC2 Instance Connect](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-methods.html), with interactive fuzzy search powered by [`fzf`](https://github.com/junegunn/fzf).
![Scrrenshort](https://github.com/yboikov/aws-instance-connect-zsh/blob/b13ffa2932874d5b395a900b95623dd014d50607/Screenshot.png)
## ✨ Features

- 🔍 **Fuzzy Search** EC2 instances with `fzf`
- 🎯 **Filter Support** via EC2 filters (e.g. state, tags, instance type)
- ⚡ **Connect** directly via EC2 Instance Connect
- 🔁 **Refresh** instance list on demand
- 📋 **Copy instance name** to clipboard
- 📋 **Copy IP** to clipboard

## 🔧 Requirements

- [AWS CLI](https://aws.amazon.com/cli/) configured (`aws configure`)
- [`fzf`](https://github.com/junegunn/fzf)
- Zsh with Oh My Zsh
- Clipboard utility:
  - macOS: `pbcopy` 
  - Linux (X11): `xclip`
  - Linux (Wayland): `wl-copy`
## 📦 Installation

Clone into your Oh My Zsh custom plugins directory:

```bash
git clone https://github.com/yboikov/aws-instance-connect-zsh.git ~/.oh-my-zsh/custom/plugins/aws-instance-connect-zsh
```

Then enable the plugin in your `.zshrc`:

```bash
plugins=(... aws-instance-connect-zsh)
```

## 🚀 Usage

### Basic Connect

```bash
_aws_instance_connect_ssh
```

Or define a filtered alias:

```bash
# Only show running instances
alias eic='_aws_instance_connect_ssh "Name=instance-state-name,Values=running"'
```

Then just run:

```bash
eic
```
### Fzf Options example
```bash
# in .zshrc
AWS_INSTANCE_CONNECT_ZSH_FZF_OPTS=(
            --border 
            --prompt="Search: "
            --header="<Enter>: Connect | <C-i>: copy ip | <C-n>: copy name | <C-/>: hide/show details"
            --color header:italic
            --color header:dim
            --color 'bg:-1'
            --tmux bottom,50%
            --layout=default
            --preview-label="Details"
            --no-mouse
            )

```
### Other overrides
```bash
# Append to aws ec2-instance-connect ssh 
AWS_INSTANCE_CONNECT_ZSH_COMMAND_ARGS=()

```
### Key Bindings Inside fzf

While inside the fzf prompt:

- **Enter** – Connect to the selected EC2 instance using EC2 Instance Connect
- **Ctrl-R** – Refresh the instance list
- **Ctrl-N** – Copy the selected instance's name to clipboard
- **Ctrl-I** – Copy the public IP of the selected instance to clipboard

> Clipboard commands rely on `pbcopy`, `xclip`, or `wl-copy`, depending on your OS.



## 📝 Example Filters

You can customize the behavior via filters passed to the AWS CLI:

```bash
# By instance tag
alias eic_web='_aws_instance_connect_ssh "Name=tag:Role,Values=web-server"'

# By instance type
alias eic_gpu='_aws_instance_connect_ssh "Name=instance-type,Values=g4dn.xlarge"'

# Multiple filters
alias eic='_aws_instance_connect_ssh Name=instance-state-name,Values=running Name=tag:Owner,Values=DevTeam1'
```

### Run command before connect
```bash
# sets tab title to instance name - in tmux
AWS_INSTANCE_CONNECT_ZSH_PRE_CMD='[[ "${instance_name}" == "N/A" ]] && printf "\033]2;󰌘 ${instance_id}\007" || printf "\033]2;󰌘 ${instance_name}\007"'

```
