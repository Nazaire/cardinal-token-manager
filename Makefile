.PHONY: install test-keys build start test clean-test-keys stop

TEST_KEY := $(shell solana-keygen pubkey ./tests/test-key.json)

all: install test-keys build start test clean-test-keys stop

install:
	yarn install

test-keys:
	mkdir -p target/deploy
	cp -r tests/test-keypairs/* target/deploy
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/39xubSermwXqcSPu2qEHSspGVmsVZYBnA8RbFqhMLbFK/$$(solana-keygen pubkey tests/test-keypairs/cardinal_token_manager-keypair.json)/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/Hv6ppuT2mvHjgpSQVuQnvT4hUTLjr1XgrqKyVbqzWRpu/$$(solana-keygen pubkey tests/test-keypairs/cardinal_paid_claim_approver-keypair.json)/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/AmoML37av2K7Cn4p5s2uYvdftC6v47RQveaAD1vPEGck/$$(solana-keygen pubkey tests/test-keypairs/cardinal_time_invalidator-keypair.json)/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/Ea82cLwGjJgFNwvNqKW3bBHBefWmN2n36C7roQMeiY7R/$$(solana-keygen pubkey tests/test-keypairs/cardinal_use_invalidator-keypair.json)/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/3GT5Q6wwXwfDUcMAn6h4XCtmqSVFLp9eL7WQjKshNK3L/$$(solana-keygen pubkey tests/test-keypairs/cardinal_payment_manager-keypair.json)/g" {} +

build:
	anchor build
	yarn idl:generate

start:
	solana-test-validator --url https://api.mainnet-beta.solana.com \
		--clone metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s --clone PwDiXFxQsGra4sFFTT8r1QWRMd4vfumiWC1jfWNfdYT \
		--bpf-program ./target/deploy/cardinal_token_manager-keypair.json ./target/deploy/cardinal_token_manager.so \
		--bpf-program ./target/deploy/cardinal_paid_claim_approver-keypair.json ./target/deploy/cardinal_paid_claim_approver.so \
		--bpf-program ./target/deploy/cardinal_time_invalidator-keypair.json ./target/deploy/cardinal_time_invalidator.so \
		--bpf-program ./target/deploy/cardinal_use_invalidator-keypair.json ./target/deploy/cardinal_use_invalidator.so \
		--bpf-program ./target/deploy/cardinal_payment_manager-keypair.json ./target/deploy/cardinal_payment_manager.so \
		--reset --quiet & echo $$! > validator.PID
	sleep 5
	solana-keygen pubkey ./tests/test-key.json
	solana airdrop 1000 $(TEST_KEY) --url http://localhost:8899

test:
	anchor test --skip-local-validator --skip-build --skip-deploy --provider.cluster localnet

clean-test-keys:
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_token_manager-keypair.json)/39xubSermwXqcSPu2qEHSspGVmsVZYBnA8RbFqhMLbFK/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_paid_claim_approver-keypair.json)/Hv6ppuT2mvHjgpSQVuQnvT4hUTLjr1XgrqKyVbqzWRpu/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_time_invalidator-keypair.json)/AmoML37av2K7Cn4p5s2uYvdftC6v47RQveaAD1vPEGck/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_use_invalidator-keypair.json)/Ea82cLwGjJgFNwvNqKW3bBHBefWmN2n36C7roQMeiY7R/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_payment_manager-keypair.json)/3GT5Q6wwXwfDUcMAn6h4XCtmqSVFLp9eL7WQjKshNK3L/g" {} +

stop:
	pkill solana-test-validator