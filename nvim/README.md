# Jiuh.star 的 NeoVim 配置

基于 `lazy.nvim` 的模块化配置，面向 Lua / Python / TypeScript / Vue / Typst 的日常开发，搭配 Neovide 使用。

## 目录结构

```text
nvim/
├── init.lua              # 入口
└── lua/
    ├── config/           # 基础配置
    │   ├── options.lua
    │   ├── autocmds.lua
    │   ├── keys.lua
    │   ├── lazy.lua
    │   ├── icons.lua
    │   └── neovide.lua
    ├── lib/              # 维护起来很麻烦的，深度定制的插件和模块
    │   ├── foldtext.lua
    │   ├── vue.lua
    │   └── heirline/
    └── plugins/          # 插件声明
        ├── lsp.lua
        ├── coding.lua
        ├── editor.lua
        ├── ui.lua
        └── snacks.lua
```

## 安装

将配置链接到 Neovim 的配置目录：

```bash
ln -s "$(pwd)/nvim" ~/.config/nvim
ln -s "$(pwd)/neovide" ~/.config/neovide
```


## 依赖

| 依赖 | 用途 |
| --- | --- |
| Neovim 0.12+ | 本体 |
| git | 插件与 lazy.nvim 引导 |
| tree-sitter CLI | 编译 treesitter parser |
| ripgrep、fd | 搜索与文件查找 |
| lazygit | `Snacks.lazygit` |
| ImageMagick | `snacks.image` 图片渲染 |
| node | Copilot 与部分 LSP |
| Nerd Font | 图标 |
| Neovide | 可选 GUI，相关配置见 `config/neovide.lua` |


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
- `neogen` — 自动注解生成
- `nvim-lint` — linter
- `mason-nvim-lint` — linter 安装、默认配置

### 语法与格式化

- `tree-sitter-manager.nvim` — treesitter parser 的安装与高亮
- `conform.nvim` — 格式化
- `typst-preview.nvim` — typst 语法高亮、LSP、Live Preview
- `markview.nvim` — markdown、typst、latex、html 等格式的渲染预览

### 界面

- `catppuccin` — 配色
- `heirline.nvim` — 状态栏
- `bufferline.nvim` — tabline
- `mini.icons` — 图标
- `noice.nvim` — 消息 UI 与 cmdline
- `dropbar.nvim` — 面包屑
- `todo-comments.nvim` — TODO 高亮
- `which-key.nvim` — 键位提示
- `nvim-treesitter-context` — 代码上下文

### 编辑

- `gitsigns.nvim` — git 支持
- `nvim-autopairs` — 括号配对
- `nvim-ts-autotag` — HTML 标签自动闭合
- `guess-indent.nvim` — 缩进探测
- `diffview.nvim` — 审查变更文件
- `treesj` — 代码块拆分与合并
- `nvim-colorizer.lua` — 颜色值高亮，支持 tailwind

### 测试与任务

- `neotest` — 测试管理，目前接入 `neotest-python`
- `overseer.nvim` — 任务运行器


## 快捷键


| 前缀 | 功能 |
| --- | --- |
| `<leader>f` | 查找文件、项目、最近文件 |
| `<leader>g` | Git（lazygit、分支、log、diff 等） |
| `<leader>u` | 界面开关（dim、zen、缩进线等） |
| `<leader>s` | 搜索（grep、诊断、命令、帮助等） |
| `<leader>l` | 语言（格式化、跳转、注解、lint） |
| `<leader>t` | 测试（运行、监视、输出） |


常用按键：

| 按键 | 功能 |
| --- | --- |
| `<leader><space>` | 智能查找文件 |
| `<leader>/` | 全局搜索 |
| `<leader>e` | 文件浏览器 |
| `<leader>,` | 切换缓冲区 |
| `<leader>gg` | lazygit |
| `<leader>?` | 当前缓冲区键位 |
| `<C-/>` | 终端 |
| `gm` | 拆分 / 合并代码块 |
| `]]` / `[[` | 下一个 / 上一个引用 |


### 备注

- Neovide 0.17 下对 `noice.nvim` 与 `vim._core.ui2` 做了延迟初始化以规避警告。
- Neovide 快捷键：`<C-=>` / `<C-->` / `<C-0>` 调整缩放，`<M-]>` / `<M-[>` 调整透明度，`:Neovide fullscreen|profile` 切换全屏与性能分析。

