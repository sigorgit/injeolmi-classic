import { BigNumber } from "@ethersproject/bignumber";
import fs from "fs";
import superagent from "superagent";

const TOTAL_PAGE = 59;

(async () => {
    const addresses: string[] = [];
    const promises: Promise<void>[] = [];
    for (let page = 1; page <= TOTAL_PAGE; page += 1) {
        promises.push(new Promise(async (resolve) => {
            const run = async () => {
                try {
                    const result = (await superagent.get(`https://api-cypress.scope.klaytn.com/v1/tokens/0x0af3f3fe9e822b7a740ca45ce170340b2da6f4cc/holders?page=${page}`)).body;
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