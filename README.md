# 个人博客

## 设计
主要发布在两个地方：
1. Github Pages：作为镜像。
2. 自己的服务器：作为主站。

## 部署
- 部署到Github Pages：`./.github/workflows/pages.yml`。通过Hexo生成静态页面部署到Github Pages。
- 部署到自己的服务器：`./.github/workflows/selfhost.yml`。实际上就是生成静态页面前替换域名，再将生成好的静态文件全部上传到服务器。

## 脚本
- `prepare.sh`：用于替换域名
- `deploy.sh`：手动部署博客
- `replace_img.sh`：替换_posts目录中的图片路径（_posts中编辑文件需要用../img/来引用图片，可是发布的时候需要替换成img/网页才能找到图片，所以用脚本再发布时替换一下）。
