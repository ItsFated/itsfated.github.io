docker compose -f compose.yaml down
mkdir -p ./{data,logs}
./prepare.sh
npm install
npm run build
docker compose -f compose.yaml up -d