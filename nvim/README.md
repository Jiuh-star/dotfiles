# Jiuh.star 的 NeoVim 配置

## 依赖

NeoVim 0.12+, git, tree-sitter CLI, ripgrep、fd, lazygit, ImageMagick, node, Nerd Font


## 插件

### 查找

- `snacks.nvim` — picker、终端、图片、滚动、缩进线、状态列等
- `fzf-lua` — 模糊查找（备选）

### LSP 与补全

- `nvim-lspconfig` — LSP 客户端配置
- `mason.nvim` — LSP、格式化器等外部工具的安装
- `mason-lspconfig.nvim` — mason 与 lspconfig 的桥接
- `blink.cmp` — 补全
- `copilot.lua` — AI 补全
- `lazydev.nvim` — lua 补全，添加 wezterm 与 xmake 的类型库

### 语法与格式化

- `tree-sitter-manager.nvim` — treesitter parser 的安装与高亮
- `conform.nvim` — 格式化

### 界面

- `catppuccin` — 配色
- `heirline.nvim` — 状态栏
- `bufferline.nvim` — tabline
- `mini.icons` — 图标
- `noice.nvim` — 消息 UI 与 cmdline
- `dropbar.nvim` — 面包屑
- `todo-comments.nvim` — TODO 高亮
- `which-key.nvim` — 键位提示

### 编辑

- `gitsigns.nvim` — git 支持
- `nvim-autopairs` — 括号配对
- `nvim-ts-autotag` — HTML 标签自动闭合
- `guess-indent.nvim` — 缩进探测


## 配置

### `autocmds`

- 只在活动窗口显示 cursorline
- 文件名称无关的备份（通过在备份文件后附加文件路径，需要 `backupdir`）


## TODOs

- [ ] 更合理的 `which-keys.nvim` 配置。

