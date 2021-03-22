set -e
set -x

CURDIR=$(dirname "$0")

rm -rf ~/.relayer

rly config init

rly chains add -f $CURDIR/shentu.json
rly chains add -f $CURDIR/regen.json


SHENTU_MNEMONIC=$(jq -r '.mnemonic' $CURDIR/yulei_user_key.json)
REGEN_MNEMONIC=$(jq -r '.mnemonic' $CURDIR/regen_user_key.json)


rly keys restore yulei-1 testkey "$SHENTU_MNEMONIC"
# certik1z3ajg4snv04suxdr2ndjvh40rskpg3z86up26m

rly keys restore regen-1 testkey "$REGEN_MNEMONIC"
# regen157yf60r2653829kgvzl7k7es9rtjm92jcnp53e



# rly keys add yulei-1 relayer-certik
# rly keys add regen-1 relayer-regen
# # rly ch edit yulei-1 key relayer-petom
# # rly ch edit aplikigo-1 key relayer-pylon
# certik keys add ibc-test
# regen keys add ibc-test


rly config add-paths $CURDIR/paths


rly light init yulei-1 -f
rly light init regen-1 -f


rly q bal yulei-1 testkey
rly q bal regen-1 testkey



#certik tx bank send faucet $(certik keys show user -a) 10000000000uctk --chain-id yulei-1 --fees 5000uctk 
#regen tx bank send faucet $(regen keys show user -a) 10000000000stake --chain-id regen-1 --fees 5000stake  --node tcp://localhost:26557

rly chains list
rly paths list

rly tx link demo -d -o 3s



certik --home ~/.certik start --pruning=nothing --grpc.address=0.0.0.0:9090 --rpc.laddr=tcp://0.0.0.0:26657

regen --home ~/.regen start --pruning=nothing --grpc.address=0.0.0.0:9091 --rpc.laddr=tcp://0.0.0.0:26557





