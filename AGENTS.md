# Agent 工作规则

## 项目语言约定

### 保持中文的内容（不会在运行时输出）
- **注释** — YAML、脚本、配置文件中所有注释
- **文档** — `README.md` 等说明文档
- **变量文件注释** — `group_vars/`、`host_vars/`、`vars/` 中的注释
- **Vault 文件注释** — 加密文件内的注释文字

### 使用英文的内容（会在终端/运行时输出）
- **Playbook/Task name** — `- name: ` 字段（Ansible 运行时显示）
- **Shell 脚本 echo** — `run.sh` 等脚本的输出信息
- **Debug 消息** — Ansible `debug` 模块的输出

### 格式约定
- 运行时输出：用简洁英文 + ASCII 标记（`[INFO]`、`[OK]`、`[ERROR]`、`[WARN]`、`[CHECK]`）
- 不要使用 emoji 或特殊 Unicode 图标
- 注释和文档：正常写中文即可
