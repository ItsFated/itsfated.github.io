---
title: Hexo
date: 2024-07-12 13:00:58
tags:
  - 博客
  - 网站
  - Github
  - NodeJS
---

  
  
- 官网：[hexo](https://hexo.io/zh-cn/)

	- Github：[hexo](https://github.com/hexojs/hexo)

- 部署记录：[文档](https://hexo.io/zh-cn/docs/)

	- [Install NodeJS](https://nodejs.org/en/download/package-manager)
	    
  
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

	- 安装Hexo
	    
  
	  ```shell
	  # 全局
	  npm install -g hexo-cli
	  # 局部
	  npm install hexo
	  ```

	- Hello World
	    
  
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

- 在GitHub上部署Hexo

	- [在 GitHub Pages 上部署 Hexo](https://hexo.io/zh-cn/docs/github-pages)

		- GitHub上找一个Hexo仓库（可以是自己的用户名仓库），下载到本地安装`hexo-deployer-git`
		    
  
		  ```shell
		  # 安装：hexo-deployer-git
		  npm install hexo-deployer-git --save
		  git add .
		  git commit -m "install hexo-deployer-git"
		  # 注意需要将GitHub仓库中的Pages改为Actions！！！再继续！！！
		  # 修改 .github/workflows/pages.yml （创建新文件）
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
		  # 修改 _config.yml（部分）
		  url: https://itsfated.github.io/itsfated
		  deploy:
		    type: 'git'
		    repo: git@github.com:ItsFated/itsfated.git
		    branch: gh-pages
		  # 提交修改后会自动执行Actions
		  ```
