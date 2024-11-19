import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const HelloWorldModule = buildModule("HelloWorldModule", (m) => {
  const contract = m.contract("HelloWorld");
  return { contract };
});

export default HelloWorldModule;
