import fs from "fs";

(async () => {
    const raw = fs.readFileSync("raw.txt");
    const splits = raw.toString().split("\n");
    const addresses: string[] = [];
    for (const split of splits) {
        if (split.indexOf("0x") === 0) {
            const address = split.trim();
            if (address.length === 42 && addresses.includes(address) !== true) {
                addresses.push(address);
            }
        }
    }
    fs.writeFileSync("addresses.txt", JSON.stringify(addresses));
})();