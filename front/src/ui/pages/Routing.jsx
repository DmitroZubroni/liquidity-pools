import {Header} from "../component/Header.jsx";
import RoutingService from "../../service/routingService/RoutingService.jsx";
import {useContext} from "react";
import {Button, Form} from "react-bootstrap";
import {AppContext} from "../../core/context/context.jsx";

const Routing = () => {

    const {wallet} = useContext(AppContext);
    const trade = async (e) => {
        e.preventDefault();
        const supplyToken = e.target[0].value;
        const demandToken = e.target[1].value;
        const supplyAmount = e.target[2].value * 10 ** 12;
        await RoutingService.trade(demandToken, supplyToken, supplyAmount, wallet);
    }



    return (
        <div>
            <Header />
            <Form onSubmit={trade} className="center">
                <h2> обмен токенов </h2>
                <Form.Group controlId="addliquidity">
                    <Form.Label column={1}> токен спроса </Form.Label>
                    <Form.Control/>
                </Form.Group>

                <Form.Group controlId="addliquidity">
                    <Form.Label column={1}> токен предложения </Form.Label>
                    <Form.Control/>
                </Form.Group>

                <Form.Group controlId="addliquidity">
                    <Form.Label column={1}> количество  </Form.Label>
                    <Form.Control/>
                </Form.Group>


                <Button variant="primary" type="submit">go</Button>
            </Form>
        </div>
    )
}
export default Routing