docker compose -f compose.yaml down
mkdir -p ./{data,logs}
./prepare.sh itsfated.top 替换appId 替换appKey 替换repo_id 替换category_id
npm install
npm run build
docker compose -f compose.yaml up -d