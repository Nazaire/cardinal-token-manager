.PHONY: install test-keys build start test clean-test-keys stop

TEST_KEY := $(shell solana-keygen pubkey ./tests/test-key.json)

all: install test-keys build start test clean-test-keys stop

install:
	yarn install

test-keys:
	mkdir -p target/deploy
	cp -r tests/test-keypairs/* target/deploy
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/9WDgSgB9S54ui97UfY2shegJ764ScgwjDRLEhqLYS3e/$$(solana-keygen pubkey tests/test-keypairs/cardinal_token_manager-keypair.json)/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/9ekqCtEXJVRU5jdGxknES8Rs4nwF8g9ETagDtGUVAvTB/$$(solana-keygen pubkey tests/test-keypairs/cardinal_paid_claim_approver-keypair.json)/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/4SXNGLfQVMxrTJdJNArtfCM14grtzseH7ja8dMHCJpf8/$$(solana-keygen pubkey tests/test-keypairs/cardinal_time_invalidator-keypair.json)/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/CrqZJ1frYpEvmJDR4zKpJNicrPDNwKKUKevetmk7Eajo/$$(solana-keygen pubkey tests/test-keypairs/cardinal_use_invalidator-keypair.json)/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/4nYmFoLLdYiHhceqWWaF2Hjmx2TUWg4FQQfYpWCMmg5n/$$(solana-keygen pubkey tests/test-keypairs/cardinal_payment_manager-keypair.json)/g" {} +

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
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_token_manager-keypair.json)/9WDgSgB9S54ui97UfY2shegJ764ScgwjDRLEhqLYS3e/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_paid_claim_approver-keypair.json)/9ekqCtEXJVRU5jdGxknES8Rs4nwF8g9ETagDtGUVAvTB/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_time_invalidator-keypair.json)/4SXNGLfQVMxrTJdJNArtfCM14grtzseH7ja8dMHCJpf8/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_use_invalidator-keypair.json)/CrqZJ1frYpEvmJDR4zKpJNicrPDNwKKUKevetmk7Eajo/g" {} +
	LC_ALL=C find programs src -type f -exec sed -i '' -e "s/$$(solana-keygen pubkey tests/test-keypairs/cardinal_payment_manager-keypair.json)/4nYmFoLLdYiHhceqWWaF2Hjmx2TUWg4FQQfYpWCMmg5n/g" {} +

stop:
	pkill solana-test-validator