import {Web3} from "web3";
import abi from "./abi.json";

class FactoryService {

    web3 = new Web3(window.ethereum)
    contractAddress = "0x02774BD754dFCFCADe1FD152E69DFD8DC30e2788"
    contract = new this.web3.eth.Contract(abi, this.contractAddress)

    async createPool(tokenA, tokenB, reserveA, reserveB, wallet) {
        await this.contract.methods.createPool(tokenA, tokenB, reserveA, reserveB).send({from: wallet});
    }


    async getPool(wallet) {
       return  await this.contract.methods.getPool().call({from: wallet});
    }

    async getBalance(wallet) {
        return await this.contract.methods.getBalance().call({from: wallet});
    }
}

export default new FactoryService;