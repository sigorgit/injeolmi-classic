import fs from "fs";
import superagent from "superagent";

const TOTAL_PAGE = 5;

(async () => {
    const addresses: string[] = [];
    const promises: Promise<void>[] = [];
    for (let page = 1; page <= TOTAL_PAGE; page += 1) {
        promises.push(new Promise(async (resolve) => {
            const run = async () => {
                try {
                    const result = (await superagent.get(`https://api-cypress.scope.klaytn.com/v1/tokens/0x67c11ff997c0ec018bcc107c5be52b515504d663/holders?page=${page}`)).body;
                    for (const data of result.result) {
                        addresses.push(data.address);
                    }
                } catch (error) {
                    console.log(error, "Retry...");
                    await run();
                }
            };
            await run();
            resolve();
        }));
    }
    await Promise.all(promises);
    fs.writeFileSync("./nft-holders.txt", JSON.stringify(addresses));
})();