import {Web3} from "web3";
import abi from "./abi.json";

class StakingService {

    web3 = new Web3(window.ethereum)
    contractAddress = "0xa499aF577195f3dC4cFea074e867954a86C57beC"
    contract = new this.web3.eth.Contract(abi, this.contractAddress)

    async deposit(amount, wallet) {
        await this.contract.methods.deposit(amount).send({from: wallet});
    }


    async claimReward( wallet) {
        await this.contract.methods.claimReward().send({from: wallet});
    }

    async getStaking(wallet) {
         return await this.contract.methods.getStaking().call({from: wallet});
    }
}

export default new StakingService;