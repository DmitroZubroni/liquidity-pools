import {Header} from "../component/Header.jsx";
import {useContext, useEffect, useState} from "react";
import {Button} from "react-bootstrap";
import {AppContext} from "../../core/context/context.jsx";
import FactoryService from "../../service/factoryService/FactoryService.jsx";

const Personal = () => {
    const[balance, setBalance] = useState("");
    const {wallet, login} = useContext(AppContext);

    useEffect(() => {
        (async () => {
            const info = await FactoryService.getBalance(wallet);
            setBalance(info);
            console.log(info);
        }) ()
    }, [wallet]);

    return (
        <div>
            <Header />
            {wallet.length === 0 ?
            <Button onClick={login}> авторизоваться </Button> :
                <div className="center">
                    <h2> ваш баланс</h2>
                    <p>Gerda {(Number(balance.gerdaBalance) / 10 ** 12).toFixed()}</p>
                    <p>Krendel {(Number(balance.krendelBalance ) / 10 ** 12).toFixed()}</p>
                    <p>RTK {(Number(balance.rtkBalance ) / 10 ** 12).toFixed()}</p>
                    <p>RTK {(Number(balance.lpBalance ) / 10 ** 12).toFixed()}</p>
                    <p>ETH {(Number(balance.ethBalance ) / 10 ** 18).toFixed()}</p>
                </div>
            }
        </div>
    )
}
export default Personal