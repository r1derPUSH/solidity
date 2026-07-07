# MyToken — ERC-20 Token (Foundry)

Простий ERC-20 токен, написаний на Solidity з використанням Foundry та OpenZeppelin.

## Що вміє

- Стандартний ERC-20: `transfer`, `approve`, `transferFrom`, `balanceOf`
- Mint доступний лише власнику контракту (`onlyOwner`)
- Початкове постачання задається при деплої

## Стек

- Solidity ^0.8.13
- Foundry (forge, cast, anvil)
- OpenZeppelin Contracts

## Тестування

```bash
forge test -vv
```

Покриття включає:

- Юніт-тести (баланси, перекази, mint, approve/transferFrom)
- **Fuzz-тести** — Foundry прогоняє сотні випадкових значень для перевірки інваріантів (наприклад, що сума балансів завжди = totalSupply)

```bash
forge test --match-test testFuzz -vv
```

## Деплой на Sepolia

Контракт задеплоєний на Sepolia testnet:

**Адреса контракту:** `0x...` (додай після деплою)
**Etherscan:** https://sepolia.etherscan.io/address/0x...

### Як задеплоїти самостійно

```bash
forge create src/MyToken.sol:MyToken \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --constructor-args 1000000000000000000000
```

## Структура

```
src/MyToken.sol      — основний контракт
test/MyToken.t.sol    — юніт + fuzz тести
```
