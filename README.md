# arch-setup

基于 Ansible 的 Arch Linux 桌面环境一键配置工具。

## 快速开始

```bash
git clone <repo-url> && cd arch-setup
VAULT_PASS=your-vault-password ./run.sh
```

## 功能

| 模块 | 说明 |
|---|---|
| 包管理 | 安装官方包 + AUR 包（yay） |
| 系统配置 | 主机名、时区、locale、键盘布局、sudo 免密码 |
| 网络 | systemd-networkd 静态 IP、DNS、WiFi（iwd） |
| 安全 | root/wilson 密码（vault 加密）、SSH key |
| 桌面 | sway、waybar、fcitx5 输入法、PipeWire 音频 |
| dotfiles | bashrc、bash_profile、sway 配置、fcitx5 配置、GTK 设置 |
| 存储 | rclone WebDAV 挂载 |
| 定时 | reflector 定时更新镜像源 |

## 使用

### 前置依赖（运行 run.sh 之前）

- **ansible** — 核心工具，必须预先安装

> 其他所有软件包（含 python、openssh、桌面环境等）均由 playbook 自动安装，无需手动准备。

```bash
# 安装 ansible
sudo pacman -S ansible

# 一键配置
VAULT_PASS=your-vault-password ./run.sh
```

> ⚠️ 首次运行会提示输入 sudo 密码（BECOME password），用于 ansible 提权安装包和配置系统。
> 如果已经配好 sudo 免密码，则不会弹窗。

### Vault 加密

敏感信息（密码、密钥）使用 Ansible Vault 加密，存储在 `vars/secrets.yml` 和 `host_vars/*/vault.yml` 中。

```bash
# 查看加密内容
ansible-vault view vars/secrets.yml

# 编辑
ansible-vault edit vars/secrets.yml

# 运行（环境变量方式，推荐）
VAULT_PASS=your-vault-password ./run.sh

# 运行（交互输入密码）
./run.sh
```

## 项目结构

```
├── run.sh                  # 一键运行
├── inventory.yml           # 主机清单
├── AGENTS.md               # Agent 工作规则
├── group_vars/all.yml      # 通用配置
├── host_vars/              # 各主机独有配置
├── vars/secrets.yml        # 加密密钥
├── playbooks/              # Ansible playbook
├── tasks/                  # 任务定义
├── files/                  # 静态文件
│   ├── dotfiles/           # 用户配置文件
│   ├── systemd/            # systemd 服务配置
│   └── sudoers.d/          # sudo 规则
└── templates/              # Jinja2 模板
    ├── iwd/                # WiFi 配置模板
    ├── network/            # 网络配置模板
    └── rclone/             # rclone 配置模板
```
