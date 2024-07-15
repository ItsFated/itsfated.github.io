---
title: Hugo
date: 2024-07-14 09:51:03
description: 记录一次搭建Hugo博客系统的配置
cover: /img/banner.jpg
keywords:
  - 博客
  - 网站
  - Github
  - Golang
  - Hugo
tags:
  - 博客
  - 网站
  - Github
  - Golang
  - Hugo
categories:
  - 建站
---


# 首次部署
[安装hugo](https://gohugo.io/installation/)
- [Linux安装hugo](https://gohugo.io/installation/linux/)：`sudo snap install hugo`
- [Windows安装hugo](https://gohugo.io/installation/windows/)：`winget install Hugo.Hugo.Extended`

[安装Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- winget安装：`winget install Git.Git`
- 下载安装包：[Download for Windows](https://git-scm.com/download/win)

创建第一个项目：[Quick start](https://gohugo.io/getting-started/quick-start/)
```shell
# 官网指导
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
echo "theme = 'ananke'" >> hugo.toml
hugo server
# 启动
hugo server
# 启动时指定绑定端口和IP
hugo server -p 8080 --bind 192.168.108.132
```
基础操作：[Front matter（前言）](https://gohugo.io/content-management/front-matter/)
```shell
# 创建页面
hugo new content content/posts/my-first-post.md
# 修改页面属性
vi content/posts/my-first-post.md
# 参考以下内容修改
+++
title = 'My First Post'
date = 2024-01-14T07:07:07+01:00
draft = false
params:
  author: Jason
weight: 0
tags:
- 测试
genres:
- 记录
+++
```
- [weight](https://gohugo.io/content-management/front-matter/#weight)：设置页面排序权重（升序），0或无会排在最后
- [tags & genres](https://gohugo.io/content-management/front-matter/#taxonomies)：页面标签和分类
- [draft](https://gohugo.io/content-management/front-matter/#draft)：草稿，用于控制是否发布

选择主题：[Themes](https://themes.gohugo.io/)，每个主题配置不太一样，最好直接参考主题的官网。
# 部署到Github：[Host on GitHub Pages](https://gohugo.io/hosting-and-deployment/hosting-on-github/)
首先得找到一个hugo仓库，添加一个workflows文件：`.github/workflows/hugo.yaml`。然后提交到Github仓库，会自动发布页面。
```yaml
# Sample workflow for building and deploying a Hugo site to GitHub Pages
name: Deploy Hugo site to Pages

on:
  # Runs on pushes targeting the default branch
  push:
    branches:
      - main

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

# Default to bash
defaults:
  run:
    shell: bash

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.128.0
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb          
      - name: Install Dart Sass
        run: sudo snap install dart-sass
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 1
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5
      - name: Install Node.js dependencies
        run: "[[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true"
      - name: Build with Hugo
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
          TZ: Asia/Shanghai
        run: |
          hugo \
            --gc \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"          
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

