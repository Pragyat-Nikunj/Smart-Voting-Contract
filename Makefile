-include .env

.PHONY: all test clean deploy help install build anvil 

DEFAULT_ANVIL_KEY := ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=\"--network sepolia\"]"
	@echo "  make start-vote [ARGS=\"--network sepolia\"]"
	@echo "  make reset-vote [ARGS=\"--network sepolia\"]"

all: clean install build

# Clean the repo
clean  :; forge clean

# Install core dependencies
install :; forge install cyfrin/foundry-devops@0.2.1 --no-commit && forge install foundry-rs/forge-std@v1.8.1 --no-commit

build:; forge build

test :; forge test 

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

# Network Configuration
NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif

# --- Deployment ---
deploy:
	@forge script script/MemberVote.s.sol:DeployMemberVote $(NETWORK_ARGS)

# --- Interactions ---
start-vote:
	@forge script script/Interactions.s.sol:StartVote $(NETWORK_ARGS)

reset-vote:
	@forge script script/Interactions.s.sol:ResetVotes $(NETWORK_ARGS)

vote:
	@forge script script/Interactions.s.sol:Vote $(NETWORK_ARGS)