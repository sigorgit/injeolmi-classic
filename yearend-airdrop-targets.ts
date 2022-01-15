import fs from "fs";
const targets: string[] = require("./yearend-airdrop-targets.json");
const newTargets: string[] = [];
for (const target of targets) {
    if (target.length === 42 && newTargets.includes(target) !== true) {
        newTargets.push(target);
    }
}
fs.writeFileSync("yearend-airdrop-new-targets.json", JSON.stringify(newTargets).replace(/\"\,\"/g, "\",\n\""));