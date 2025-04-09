import Swap from "./swap.jsx";
import TokenInfo from "./TokenInfo.jsx";
import Addliquidity from "./Addliquidity.jsx";

const PoolCard = ({poolAddress}) => {
    console.log("PoolCard получил poolAddress:", poolAddress);
    return (
        <div className="pool">
            <Swap poolAddress={poolAddress}/>
            <TokenInfo poolAddress={poolAddress}/>
            <Addliquidity poolAddress={poolAddress}/>
        </div>
    )
}
export default PoolCard;