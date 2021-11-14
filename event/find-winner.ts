import fs from "fs";

(async () => {
    const raw = fs.readFileSync("addresses.txt");
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
    const founds: string[] = [];
    const find = () => {
        const found = Math.floor(Math.random() * addresses.length);
        if (founds.includes(addresses[found]) === true) {
            find();
        } else {
            founds.push(addresses[found]);
            console.log(addresses[found]);
        }
    };
    console.log("수상자 목록");
    for (let i = 0; i < 10; i += 1) {
        find();
    }
    console.log("만약 수상자 중 정보가 잘못된 경우를 위한 대기자 목록");
    for (let i = 0; i < 5; i += 1) {
        find();
    }
})();