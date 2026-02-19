const { expect } = require("chai");

describe("MizyNexus", function () {
  it("Should deploy and register node", async function () {
    const MizyNexus = await ethers.getContractFactory("MizyNexus");
    const mizy = await MizyNexus.deploy();
    
    await mizy.registerNode("SOWETO_NODE_001");
    const node = await mizy.registry("SOWETO_NODE_001");
    
    expect(node.nodeId).to.equal("SOWETO_NODE_001");
    expect(node.isActive).to.be.true;
  });
  
  it("Should record energy payment", async function () {
    const MizyNexus = await ethers.getContractFactory("MizyNexus");
    const mizy = await MizyNexus.deploy();
    
    await mizy.registerNode("SOWETO_NODE_001");
    await mizy.payUtility("SOWETO_NODE_001", 100, false, { value: 1000 });
    
    const node = await mizy.registry("SOWETO_NODE_001");
    expect(node.energyKwh).to.equal(100);
  });
});
