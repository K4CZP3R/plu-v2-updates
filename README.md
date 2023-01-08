# plu-v2-updates

## Flow

1. cd plu-v2-web && git checkout x.x.x
2. `./build_plu-v2-web.sh 1.3.0 pkey`
3. `python3 generate_json.py --arch aarch64 --version x.x.x --notes "changelog here" --app plu-v2-web`
4. git add \*
5. git commit -m 'plu-v2-web x.x.x'
6. git push
