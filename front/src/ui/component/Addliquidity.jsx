import {Button, Form, FormCheck} from "react-bootstrap";
import PoolService from "../../service/poolService/PoolService.jsx";
import {useContext} from "react";
import {AppContext} from "../../core/context/context.jsx";

const Addliquidity = ({poolAddress}) => {

    const {wallet} = useContext(AppContext);

    const addliquidity = async (e) => {
        e.preventDefault();
        const amount = e.target[0].value * 10 ** 12;
        const fromAtoB = e.target.checked;
        const servicePool = new PoolService(poolAddress);
        await servicePool.addliquidity(amount, fromAtoB, wallet);
    }

    if( wallet.length === 0){
        return;
    }

    return (
        <Form onSubmit={addliquidity} className="center">
            <h2>добавить ликвидность </h2>
            <Form.Group controlId="addliquidity">
                <Form.Label column={1}> количество </Form.Label>
                <Form.Control/>
            </Form.Group>

            <Form.Group controlId="addliquidity">
                <Form.Label column={1}> вложить в токен А?</Form.Label>
                <FormCheck/>
            </Form.Group>
            <Button variant="primary" type="submit">go</Button>
        </Form>
    )
}

export default Addliquidity