import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const Hiroshi1155NFTModule = buildModule("Hiroshi1155NFTModule", (m) => {
  const Hiroshi1155NFT = m.contract("Hiroshi1155NFT");

  return { Hiroshi1155NFT };
});

export default Hiroshi1155NFTModule;