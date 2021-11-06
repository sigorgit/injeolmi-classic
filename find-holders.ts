import { BigNumber } from "@ethersproject/bignumber";
import fs from "fs";
import superagent from "superagent";

const TOTAL_PAGE = 220;
const exclude: string[] = require("./addresses.json");
let totalAmount = BigNumber.from("0");

(async () => {
    const results: { address: string, amount: string }[] = [];
    const promises: Promise<void>[] = [];
    for (let page = 1; page <= TOTAL_PAGE; page += 1) {
        promises.push(new Promise(async (resolve) => {
            const run = async () => {
                try {
                    const result = (await superagent.get(`https://api-cypress.scope.klaytn.com/v1/tokens/0x9cfc059f64d664f92f3d0329844b8ccca4e5215b/holders?page=${page}`)).body;
                    for (const data of result.result) {
                        // 에어드롭 풀 제외
                        if (
                            data.address.toLowerCase() !== "0x9CFc059F64D664F92f3d0329844B8ccca4E5215B".toLowerCase() &&
                            data.address.toLowerCase() !== "0x1dA9E7adfB6817D42b1c9a5321992B1EF97701Ab".toLowerCase() &&
                            data.address.toLowerCase() !== "0x7D197D87Aa79E27bcdc3a62f819329deC6F81Ec2".toLowerCase()
                        ) {
                            let amount = BigNumber.from(data.amountHeld);
                            if (exclude.includes(data.address) === true) {
                                amount = amount.sub(BigNumber.from("1000000000000"));
                            }
                            amount = amount.mul(8).div(10);
                            results.push({ address: data.address, amount: amount.toString() });
                            totalAmount = totalAmount.add(amount);
                        }
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
    console.log(totalAmount.toString());

    for (let i = 0; i < results.length / 500; i += 1) {
        const addresses: string[] = [];
        const amounts: string[] = [];
        for (let j = 0; j < 500; j += 1) {
            if (results[i * 500 + j] !== undefined) {
                addresses.push(results[i * 500 + j].address);
                amounts.push(results[i * 500 + j].amount);
            }
        }
        fs.writeFileSync(`./parameters/parameter${i}.txt`, JSON.stringify(addresses) + "\n\n" + JSON.stringify(amounts));
    }
})();