import {Button, Form} from "react-bootstrap";
import FactoryService from "../../service/factoryService/FactoryService.jsx";
import {useContext, useEffect, useState} from "react";
import {AppContext} from "../../core/context/context.jsx";
import PoolCard from "./PoolCard.jsx";

const Factory = () => {

    const {wallet} = useContext(AppContext);
    const [pools,setPools] = useState([]);

    const createPool = async (e) => {
        e.preventDefault();
        const tokenA = e.target[0].value;
        const tokenB = e.target[1].value;
        const reserveA = e.target[2].value * 10 ** 12;
        const reserveB = e.target[3].value * 10 ** 12;
        await FactoryService.createPool(tokenA, tokenB, reserveA, reserveB, wallet);
    }

    useEffect(() => {
        (async () => {
            const poolAddress = await FactoryService.getPool();
            setPools(poolAddress || []);
        }) ()
    }, [])



    return (
        <div>
            {wallet.length === 0 ? <div></div> :
                <Form onSubmit={createPool} className="center">
                    <h2>создать пул</h2>

                    <Form.Group controlId="1">
                        <Form.Label column={1}> токен В </Form.Label>
                        <Form.Control/>
                    </Form.Group>

                    <Form.Group controlId="1">
                        <Form.Label column={1}> токен А </Form.Label>
                        <Form.Control/>
                    </Form.Group>

                    <Form.Group controlId="1">
                        <Form.Label column={1}> количество </Form.Label>
                        <Form.Control/>
                    </Form.Group>

                    <Form.Group controlId="1">
                        <Form.Label column={1}> количество </Form.Label>
                        <Form.Control/>
                    </Form.Group>


                    <Button variant="primary" type="submit">go</Button>
                </Form>
            }

            <div>
                {pools.length > 0 ? (
                    pools.map((pool, index) => {
                        console.log("Рендерится пул:", pool);
                        return (
                            <div key={index}>
                                <PoolCard poolAddress={pool}/>
                                <hr/>
                            </div>
                        );
                    })
                ) : (
                    <p>Нет доступных пулов</p>
                )}
            </div>

        </div>
    )
}
export default Factory;