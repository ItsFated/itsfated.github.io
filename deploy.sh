set -e
docker compose -f compose.yaml down
mkdir -p ./{data,logs}
echo 以下环境变量请先设置到Bash中，再执行本脚本
echo BASH_VAR_APPID: $BASH_VAR_APPID
echo BASH_VAR_APPKEY: $BASH_VAR_APPKEY
echo BASH_VAR_REPOID: $BASH_VAR_REPOID
echo BASH_VAR_CATEGORY_ID: $BASH_VAR_CATEGORY_ID
if [ -z "$BASH_VAR_APPID" ] || [ -z "$BASH_VAR_APPKEY" ] || [ -z "$BASH_VAR_REPOID" ] || [ -z "$BASH_VAR_CATEGORY_ID" ]; then
  echo 请先设置环境变量
  exit 1
fi
npm install
./prepare.sh itsfated.top $BASH_VAR_APPID $BASH_VAR_APPKEY $BASH_VAR_REPOID $BASH_VAR_CATEGORY_ID
npm run build
git checkout _config.butterfly.yml _config.yml
docker compose -f compose.yaml up -d