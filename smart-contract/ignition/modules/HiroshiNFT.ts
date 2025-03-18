import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const HiroshiNFTModule = buildModule("HiroshiNFTModule", (m) => {
  const HiroshiNFT = m.contract("HiroshiNFT");

  return { HiroshiNFT };
});

export default HiroshiNFTModule;