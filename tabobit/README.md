# Tabobit — SIP-010 Fungible Token (Clarity / Clarinet)

Tabobit is a SIP-010–compatible fungible token implemented in Clarity and scaffolded with Clarinet.

## Features
- SIP-010 interface compliance (transfer, metadata, balance, total-supply)
- Owner-configurable minter
- Simple, safe balance accounting

## Project layout
- `contracts/sip-010-trait.clar` — SIP-010 trait definition used locally
- `contracts/tabobit.clar` — Tabobit token implementation
- `Clarinet.toml` — Clarinet project configuration

## Requirements
- Clarinet installed and available on PATH (check with `clarinet --version`)

## Quick start
```bash
# From this directory
clarinet check
```

## Contract interface
- `get-name() -> (response (string-ascii 32) uint)`
- `get-symbol() -> (response (string-ascii 10) uint)`
- `get-decimals() -> (response uint uint)`
- `get-balance(principal) -> (response uint uint)`
- `get-total-supply() -> (response (optional uint) uint)`
- `get-token-uri() -> (response (optional (string-utf8 256)) uint)`
- `transfer(amount uint, sender principal, recipient principal, memo (optional (buff 34))) -> (response bool uint)`
- `mint(amount uint, recipient principal) -> (response bool uint)`
- `set-minter(new-minter principal) -> (response bool uint)`
- `get-owner() -> principal`
- `get-minter() -> principal`

## Authorization
- Only the current `minter` may mint. Initial minter is the `contract-owner` (the deployer).
- Only the `contract-owner` may call `set-minter`.
- `transfer` must be initiated by the `sender` (i.e. `tx-sender == sender`).

## Error codes
- `u100` — not authorized
- `u101` — insufficient balance

## Development tips
- Update token metadata by editing constants in `contracts/tabobit.clar`:
  - `TOKEN-NAME`, `TOKEN-SYMBOL`, `TOKEN-DECIMALS`
- Extend functionality (e.g., burn) by adjusting `total-supply` and balances accordingly.

## Testing
You can add tests under `tests/` using the Clarinet TypeScript test harness. Example (pseudo):
```ts
import { Clarinet, Tx, types } from "clarinet";

Clarinet.test({ name: "mint and transfer", async fn(chain, accounts) {
  const deployer = accounts.get("deployer")!;
  let block = chain.mineBlock([
    Tx.contractCall("tabobit", "mint", [types.uint(1000), types.principal(deployer.address)], deployer.address),
    Tx.contractCall("tabobit", "transfer", [types.uint(250), types.principal(deployer.address), types.principal(accounts.get("wallet_1")!.address), types.none()], deployer.address),
  ]);
  block.receipts.forEach(r => r.result.expectOk());
}});
```

## Deployment
- For mainnet/testnet, integrate with a Stacks deployment toolchain (e.g., `stacks.js`, Hiro Platform, or custom scripts). Ensure contract identifiers and principals are correct.
