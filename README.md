# Smart Voting Contract

A simple, audited-by-design voting smart contract suite built with Foundry. Minimal, production-oriented, and easy to extend.

## Features

- Pay-to-vote entry fee (configurable)
- Owner-controlled workflow: Registering → Voting → Resetting
- Prevent double-voting per election cycle
- Reset votes and increment election id
- Owner withdrawal of collected fees

## Quickstart

Requirements:
- Foundry (forge, anvil, cast)
- git

Install dependencies and build:
```sh
make install
make build
```

Run tests:
```sh
make test
```

Deploy locally (anvil):
```sh
make deploy
```

Run scripts:
- Start voting: `make start-vote` (calls [`StartVote.startVote`](script/Interactions.s.sol))
- Reset votes: `make reset-vote` (calls [`ResetVotes.resetVote`](script/Interactions.s.sol))
- Cast a vote: `make vote` (calls [`Vote.vote`](script/Interactions.s.sol))


## Tests

Unit tests:
- [`test/unit/MemberVoteTest.t.sol`](test/unit/MemberVoteTest.t.sol)
- [`test/unit/InteractionsTest.t.sol`](test/unit/InteractionsTest.t.sol)

Integration tests:
- [`test/integration/MemberVoteTest.t.sol`](test/integration/MemberVoteTest.t.sol)

Tests demonstrate:
- Workflow transitions (`startVote`, `resetVotes`)
- Voting mechanics and entry fee checks (`vote`)
- Election id increment and reset behavior
- Owner withdrawal (`withdraw`)

## Configuration

Main config: [`foundry.toml`](foundry.toml) — file system permissions and project layout.

Make common changes to:
- Entry fee via [`HelperConfig.activeNetworkConfig`](script/HelperConfig.s.sol)
- Deployment args via [`Makefile`](Makefile)

## Contributing

1. Fork and create a feature branch
2. Run `forge fmt --check` and `forge test -vvv`
3. Open a PR with tests and a short description

Relevant code locations:
- Contract: [`MemberVote`](src/MemberVote.sol)
- Scripts: [`script/MemberVote.s.sol`](script/MemberVote.s.sol), [`script/Interactions.s.sol`](script/Interactions.s.sol)
- Tests: [`test/unit`](test/unit), [`test/integration`](test/integration)

## License

This project is MIT licensed — see [`LICENSE`](LICENSE).