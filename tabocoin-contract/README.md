# Tabocoin Smart Contract

A SIP-010 compliant fungible token implementation on the Stacks blockchain.

## Overview

Tabocoin (TABO) is a fungible token smart contract built with Clarity and designed to be fully compliant with the SIP-010 standard. This ensures compatibility with wallets, exchanges, and other applications in the Stacks ecosystem.

## Features

- **SIP-010 Compliant**: Full compatibility with the fungible token standard
- **Secure Transfers**: Safe token transfer functionality with proper authorization checks
- **Mint & Burn**: Contract owner can mint new tokens and users can burn their own tokens
- **Metadata Support**: Configurable token metadata including name, symbol, decimals, and URI
- **Access Control**: Owner-only functions for sensitive operations

## Token Details

- **Name**: Tabocoin
- **Symbol**: TABO
- **Decimals**: 6
- **Standard**: SIP-010

## Contract Functions

### Public Functions

#### `transfer`
Transfer tokens from sender to recipient.
```clarity
(transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
```

#### `mint`
Mint new tokens to a recipient (owner only).
```clarity
(mint (amount uint) (recipient principal))
```

#### `burn`
Burn tokens from an account.
```clarity
(burn (amount uint) (owner principal))
```

#### `initialize`
Initialize the contract with an initial token supply (owner only).
```clarity
(initialize (initial-supply uint))
```

#### `set-token-uri`
Set the token metadata URI (owner only).
```clarity
(set-token-uri (value (optional (string-utf8 256))))
```

### Read-Only Functions

#### `get-name`
Returns the token name.
```clarity
(get-name) -> (response (string-ascii 32) uint)
```

#### `get-symbol`
Returns the token symbol.
```clarity
(get-symbol) -> (response (string-ascii 32) uint)
```

#### `get-decimals`
Returns the number of decimal places.
```clarity
(get-decimals) -> (response uint uint)
```

#### `get-balance`
Returns the token balance for a given principal.
```clarity
(get-balance (who principal)) -> (response uint uint)
```

#### `get-total-supply`
Returns the total token supply.
```clarity
(get-total-supply) -> (response uint uint)
```

#### `get-token-uri`
Returns the token metadata URI.
```clarity
(get-token-uri) -> (response (optional (string-utf8 256)) uint)
```

## Error Codes

- `u100`: Owner-only function called by non-owner
- `u101`: Transfer attempted by unauthorized user
- `u102`: Insufficient balance (currently unused)
- `u103`: Invalid amount (zero or negative)

## Setup & Development

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks smart contract development toolkit
- [Node.js](https://nodejs.org/) (for testing)

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   npm install
   ```

### Testing

Run the test suite:
```bash
npm test
```

Check contract syntax:
```bash
clarinet check
```

### Deployment

1. Deploy to testnet first for testing:
   ```bash
   clarinet publish --testnet
   ```

2. Deploy to mainnet:
   ```bash
   clarinet publish --mainnet
   ```

## Usage Examples

### Initialize Contract
```clarity
;; Initialize with 1,000,000 TABO tokens (considering 6 decimals)
(contract-call? .tabocoin initialize u1000000000000)
```

### Transfer Tokens
```clarity
;; Transfer 100 TABO tokens
(contract-call? .tabocoin transfer u100000000 tx-sender 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 none)
```

### Check Balance
```clarity
;; Check balance of a specific address
(contract-call? .tabocoin get-balance 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
```

### Mint New Tokens (Owner Only)
```clarity
;; Mint 1000 TABO tokens to a recipient
(contract-call? .tabocoin mint u1000000000 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
```

## Security Considerations

- The contract owner has significant privileges (minting, URI updates)
- Users can only transfer tokens they own or have been authorized to transfer
- All amounts must be positive (greater than zero)
- The contract follows SIP-010 standards for maximum compatibility

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## Support

For questions or issues, please open an issue on the project repository.