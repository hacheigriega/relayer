# setup-chains.sh script creates a set of keys for ibc testing
# and starts certik and regen chains.
#
# Prereq: certik, regen, relayer (rly) installed
#

set -x

killall certik
killall regen

set -e

CURDIR=$(dirname "$0")
coins="10000000000000stake,10000000000000uctk"
delegate="100000000000stake"


# shentu chain setup
rm -rf ~/.certik

certik init validator --chain-id yulei-1

certik keys add validator
certik keys add user --output json > $CURDIR/yulei_user_key.json
certik keys add faucet

certik add-genesis-account validator 10000000000000uctk
certik add-genesis-account user $coins
certik add-genesis-account faucet 10000000000000uctk

certik gentx validator 10000000000uctk --chain-id yulei-1 

certik collect-gentxs


# regen chain setup
rm -rf ~/.regen

regen init validator --chain-id regen-1

regen keys add validator
regen keys add user --output json > $CURDIR/regen_user_key.json
regen keys add faucet

regen add-genesis-account validator 10000000000000stake
regen add-genesis-account user $coins
regen add-genesis-account faucet 10000000000000stake

regen gentx validator 10000000000stake --chain-id regen-1 

regen collect-gentxs

$CURDIR/one_chain_start.sh certik yulei-1 ~/.certik 26657 26656 6060 9090 
$CURDIR/one_chain_start.sh regen regen-1 ~/.regen 26557 26556 6061 9091
