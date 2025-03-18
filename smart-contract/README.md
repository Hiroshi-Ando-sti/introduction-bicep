# 準備

以下の.envファイルを作成して下さい。
```
ALCHEMY_API_KEY=
SEPOLIA_PRIVATE_KEY=
ETHERSCAN_API_KEY=
```

## デプロイ手順
1. `npx hardhat compile` でスマートコントラクトをコンパイル
2. `npx hardhat ignition deploy ignition/modules/{file name}} --network sepolia --verify` でSepoliaにデプロイ

npx hardhat ignition deploy ./ignition/modules/HiroshiNFT.ts --network sepolia --deployment-id sepolia-deployment-hiroshinft --verify

vscode ➜ /src/smart-contract $ npx hardhat ignition deploy ./ignition/modules/HiroshiNFT.ts --network sepolia --deployment-id sepolia-deployment-hiroshinft --verify
✔ Confirm deploy to network sepolia (11155111)? … yes

Hardhat Ignition 🚀

Deploying [ HiroshiNFTModule ]

Batch #1
  Executed HiroshiNFTModule#HiroshiNFT

[ HiroshiNFTModule ] successfully deployed 🚀

Deployed Addresses

HiroshiNFTModule#HiroshiNFT - 0xE88Df35e01e3e33Df38FB0B5e324282feCeb20c2

Verifying deployed contracts

Verifying contract "contracts/HiroshiNFT.sol:HiroshiNFT" for network sepolia...
Contract contracts/HiroshiNFT.sol:HiroshiNFT already verified on network sepolia:
  - https://sepolia.etherscan.io/address/0xE88Df35e01e3e33Df38FB0B5e324282feCeb20c2#code

npx hardhat ignition verify sepolia-deployment-hiroshinft --network sepolia 


address: 0x36DA942099C028275321130B5e503f37DA446487
uri: https://i.seadn.io/s/raw/files/a02cdbb10a9305a3148d4197f0b0de20.png?auto=format&dpr=1&w=48


https://sepolia.etherscan.io/token/0xe88df35e01e3e33df38fb0b5e324282feceb20c2#code

