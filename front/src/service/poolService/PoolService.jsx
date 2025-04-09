import {Web3} from "web3";
import abi from "./abi.json";

class PoolService {

    web3 = new Web3(window.ethereum)
    contractAddress ;
    contract;

    constructor(poolAddress){
        this.contractAddress = poolAddress;
        this.contract = new this.web3.eth.Contract(abi, this.contractAddress);
    }

    async swap(amount, fromAtoB, wallet) {
        await this.contract.methods.swap(amount, fromAtoB).send({from: wallet});
    }


    async addliquidity(amount, fromAtoB, wallet) {
        await this.contract.methods.addliquidity(amount, fromAtoB).send({from: wallet});
    }

    async getToken(wallet) {
       return await this.contract.methods.getToken().call({from: wallet});
    }
}

export default PoolService;