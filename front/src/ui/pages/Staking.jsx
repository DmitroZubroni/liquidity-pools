import {Header} from "../component/Header.jsx";
import StakingService from "../../service/stakingService/StakingService.jsx";
import {useContext, useEffect, useState} from "react";
import {AppContext} from "../../core/context/context.jsx";
import {Button, Form,} from "react-bootstrap";

const Staking = () => {

    const initial = {
        rewardGo: 0n,
        stakedTokens: 0n,
        depositTime: 0n
    }
    const [staking, setStaking] = useState(initial);
    const {wallet} = useContext(AppContext);

    const deposit = async (e) => {
            e.preventDefault();
            const amount = e.target[0].value * 10 ** 12;
           await  StakingService.deposit( amount, wallet);
    }

    const claimReward = async (e) => {
        e.preventDefault();
        await  StakingService.claimReward(wallet);
    }

    useEffect(() => {
        (async () => {
            const info = await StakingService.getStaking(wallet);
            setStaking(info);
        }) ()
    }, [])



    return (
        <div>
            <Header />
            <Form onSubmit={deposit} className="center">
                <h2> вложить токены</h2>
                <Form.Group controlId="addliquidity">
                    <Form.Label column={1}> количество </Form.Label>
                    <Form.Control/>
                </Form.Group>

                <Button variant="primary" type="submit">go</Button>
            </Form>

            <Form onSubmit={claimReward} className="center">
                <h2>забрать вознаграждение </h2>
                <Button variant="primary" type="submit">go</Button>
            </Form>


            <Form className="center">
                <h2> информация о вкладе </h2>
                <p> время последнего вкалада {(Number(staking.depositTime) * 1000).toLocaleString()}</p>
                <p> колличество вложенных токенов {Number(staking.stakedTokens).toFixed()}</p>
                <p> доступная награда {Number(staking.rewardGo).toFixed()}</p>
            </Form>


        </div>
    )
}
export default Staking