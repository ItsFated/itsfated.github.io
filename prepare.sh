# 示例：
# perpare.sh itsfated.top appId appKey repo_id category_id

# 替换域名
sed -i "s#url: https://itsfated.github.io/#url: https://$1/#" _config.yml
sed -i "s#https://itsfated.github.io/atom.xml#https://$1/atom.xml#" _config.butterfly.yml

# 替换配置
sed -i "s/56a07c6f-5882-412b-b502-154543266a8b/$2/" _config.butterfly.yml
sed -i "s/ca126f51-86c5-41c5-a45c-7b584082fbcc/$3/" _config.butterfly.yml
sed -i "s/da657660-f72f-401a-bfcc-f87aa68b9997/$4/" _config.butterfly.yml
sed -i "s/e7fcd585-59b1-4dac-a218-10dc1c585b10/$5/" _config.butterfly.yml

# 替换底部自定义字符串，如：备案号
sed -i "s!348c3414-b358-4a50-be83-7d20fcb25770!$6!" _config.butterfly.yml

# 关闭评论
if [[ $7 == "no_comments" ]]; then
    sed -i "s/  use: valine,Giscus/  use: /" _config.butterfly.yml
fi