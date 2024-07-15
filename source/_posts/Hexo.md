---
title: Hexo
description: 记录一次搭建Hexo博客系统的配置
date: 2024-07-12 13:00:58
cover: /img/banner.jpg
keywords:
  - 博客
  - 网站
  - Github
  - NodeJS
  - Hexo
tags:
  - 博客
  - 网站
  - Github
  - NodeJS
  - Hexo
categories:
  - 建站
---


# 官网：[hexo](https://hexo.io/zh-cn/)
Github：[hexo](https://github.com/hexojs/hexo)
# 部署记录：[文档](https://hexo.io/zh-cn/docs/)
[Install NodeJS](https://nodejs.org/en/download/package-manager)
```shell
# 不用Root
# installs fnm (Fast Node Manager)
curl -fsSL https://fnm.vercel.app/install | bash
# download and install Node.js
fnm use --install-if-missing 22
# verifies the right Node.js version is in the environment
node -v # should print `v22.4.1`
# verifies the right NPM version is in the environment
npm -v # should print `10.8.1`
```
安装Hexo
```shell
# 全局
npm install -g hexo-cli
# 局部
npm install hexo
```
Hello World
```shell
# 创建一个项目
hexo init demo
cd demo
# 安装依赖
npm install
# 生成页面，创建项目会自带一个hello_world.md页面
hexo generate
# 运行访问：http://localhost:4000
hexo server
```
# [在 GitHub Pages 上部署 Hexo](https://hexo.io/zh-cn/docs/github-pages)
GitHub上找一个Hexo仓库（可以是自己的用户名仓库），下载到本地安装`hexo-deployer-git`
```shell
# 安装：hexo-deployer-git
npm install hexo-deployer-git --save
git add .
git commit -m "install hexo-deployer-git"
```
注意需要将GitHub仓库中的Pages改为Actions！！！再继续！！！
修改 .github/workflows/pages.yml （创建新文件，Actions文件）
```yaml
name: Pages

on:
  push:
    branches:
      - main # default branch

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          # If your repository depends on submodule, please see: https://github.com/actions/checkout
          submodules: recursive
      - name: Use Node.js 22
        uses: actions/setup-node@v4
        with:
          # Examples: 20, 18.19, >=16.20.2, lts/Iron, lts/Hydrogen, *, latest, current, node
          # Ref: https://github.com/actions/setup-node#supported-version-syntax
          node-version: "22"
      - name: Cache NPM dependencies
        uses: actions/cache@v4
        with:
          path: node_modules
          key: ${{ runner.OS }}-npm-cache
          restore-keys: |
            ${{ runner.OS }}-npm-cache
      - name: Install Dependencies
        run: npm install
      - name: Build
        run: npm run build
      - name: Upload Pages artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public
  deploy:
    needs: build
    permissions:
      pages: write
      id-token: write
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```
修改 _config.yml（部分）
```yaml
url: https://itsfated.github.io/itsfated
deploy:
  type: 'git'
  repo: git@github.com:ItsFated/itsfated.git
  branch: gh-pages
```
提交这两个文件的修改后，Github会自动执行Actions
# 配置[Butterfly](https://github.com/jerryc127/hexo-theme-butterfly)主题
参考：[Butterfly 安裝文檔(一) 快速開始](https://butterfly.js.org/posts/21cfbf15/)

第一步：修改 Hexo 根目錄下的 _config.yml，把主題改為 butterfly。
```yaml
theme: butterfly
```

第二步：安装：`npm install hexo-renderer-pug hexo-renderer-stylus --save`

第三步：[使用替代主题配置文件](https://hexo.io/zh-cn/docs/configuration#%E4%BD%BF%E7%94%A8%E4%BB%A3%E6%9B%BF%E4%B8%BB%E9%A2%98%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6)
```shell
find . -iname "_config*"
cp ./node_modules/hexo-theme-butterfly/_config.yml _config.butterfly.yml
# 后续修改主题可以直接修改 _config.butterfly.yml，如下配置开启404页面
vi _config.butterfly.yml
# 修改参考如下内容
error_404:
  enable: true
  subtitle: "页面没有找到"
```

第四步：[Butterfly 安裝文檔(二) 主題頁面](https://butterfly.js.org/posts/dc584b87/#Page-Front-matter)，子页面（tags、categries等）
```shell
hexo new page tags
vi source/tags/index.md
# 修改参考如下内容
---
title: 标签
date: 2018-01-05 00:00:00
type: "tags"
orderby: random
order: 1
---
hexo new page categories
vi source/categories/index.md
# 修改参考如下内容
---
title: 分类
date: 2018-01-05 00:00:00
type: "categories"
---
```

第五步：重新部署
```shell
hexo clean
hexo generate
hexo server
```

# 配置[Butterfly](https://github.com/jerryc127/hexo-theme-butterfly)评论系统

[**Valine**](https://valine.js.org/)是一款快速、简洁且高效的无后端评论系统，用作Hexo的评论系统非常简单快捷，而且有很多博主也用的是它：[hexo - Next 主题添加评论功能](https://yashuning.github.io/2018/06/29/hexo-Next-%E4%B8%BB%E9%A2%98%E6%B7%BB%E5%8A%A0%E8%AF%84%E8%AE%BA%E5%8A%9F%E8%83%BD/)，[国光](https://www.sqlsec.com/)……

[**Giscus**](https://giscus.app/zh-CN)是利用 [GitHub Discussions](https://docs.github.com/en/discussions) 实现的评论系统，让访客借助 GitHub 在你的网站上留下评论。
按照[官网](https://giscus.app)步骤进行：
1. 该仓库是[公开的](https://docs.github.com/en/github/administering-a-repository/managing-repository-settings/setting-repository-visibility#making-a-repository-public)，否则访客将无法查看 discussion。
2. [giscus](https://github.com/apps/giscus) app 已安装，否则访客将无法评论和回应。
3. Discussions 功能已[在你的仓库中启用](https://docs.github.com/en/github/administering-a-repository/managing-repository-settings/enabling-or-disabling-github-discussions-for-a-repository)。

修改配置文件`_config.butterfly.yml`
```yaml
comments:
  use: Giscus # Valine,Disqus
giscus:
  repo: itsfated/itsfated
  repo_id: R_kgDOMVetDQ
  category_id: DIC_kwDOMVetDc4Cgx1_
  theme:
    light: light
    dark: dark
  option:
    data-category: General
    data-mapping: title
    data-strict: 0
    data-reactions-enabled: 1
    data-emit-metadata: 0
    data-input-position: bottom
    data-theme: preferred_color_scheme
    data-lang: zh-CN
    crossorigin: anonymous
```

