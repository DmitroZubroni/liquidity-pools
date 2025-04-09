import PoolService from "../../service/poolService/PoolService.jsx";
import {useEffect, useState} from "react";
import {Form} from "react-bootstrap";

const TokenInfo = ({poolAddress}) => {

    const [poolInfo, setPoolInfo] = useState("");

    useEffect(() => {
        (async () => {
            const servicePool = new PoolService(poolAddress);
            const info = await servicePool.getToken()
            setPoolInfo(info)
        }) ()
    }, [poolAddress]);

    return (
        <div >
            <Form>
                <p> токен А: {poolInfo.nameA }</p>
                <Form.Label column={1}> токен В: {poolInfo.nameB }</Form.Label>

                <Form.Label column={1}> отношение в цене:
                    {(Number(poolInfo.priceA) / 10 ** 6).toFixed(1)} ETH -
                    {(Number(poolInfo.priceB) / 10 ** 6).toFixed(1)} ETH
                </Form.Label>

                <Form.Label column={1}> отношение в токенах
                    <p> {(Number(poolInfo.amountA) / 10 ** 12).toFixed()} - {(Number(poolInfo.amountB) / 10 ** 12).toFixed()}</p>
                </Form.Label>
            </Form>
        </div>
    )
}
export default TokenInfo