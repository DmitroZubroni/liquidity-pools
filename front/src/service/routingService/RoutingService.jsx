import {Web3} from "web3";
import abi from "./abi.json";

class RoutingService {

    web3 = new Web3(window.ethereum)
    contractAddress = "0x0B3211Ec3A5AF5D25C025BE0EAA9FB6e080890f3"
    contract = new this.web3.eth.Contract(abi, this.contractAddress)

    async trade(supplyToken, demandToken, supplyAmount, wallet) {
        await this.contract.methods.trade(supplyToken, demandToken, supplyAmount).send({from: wallet});
    }



}

export default new RoutingService;