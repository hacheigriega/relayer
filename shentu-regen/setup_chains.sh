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

certik keys add validator --keyring-backend test
certik keys add user --output json --keyring-backend test > $CURDIR/yulei_user_key.json
certik keys add faucet --keyring-backend test

certik add-genesis-account validator 10000000000000uctk --keyring-backend test
certik add-genesis-account user $coins --keyring-backend test
certik add-genesis-account faucet 10000000000000uctk --keyring-backend test

certik gentx validator 10000000000uctk --chain-id yulei-1 --keyring-backend test

certik collect-gentxs


# regen chain setup
rm -rf ~/.regen

regen init validator --chain-id regen-1

regen keys add validator --keyring-backend test
regen keys add user --output json --keyring-backend test > $CURDIR/regen_user_key.json
regen keys add faucet --keyring-backend test

regen add-genesis-account validator 10000000000000stake --keyring-backend test
regen add-genesis-account user $coins --keyring-backend test
regen add-genesis-account faucet 10000000000000stake --keyring-backend test

regen gentx validator 10000000000stake --chain-id regen-1 --keyring-backend test

regen collect-gentxs

$CURDIR/one_chain_start.sh certik yulei-1 ~/.certik 26657 26656 6060 9090 
$CURDIR/one_chain_start.sh regen regen-1 ~/.regen 26557 26556 6061 9091
