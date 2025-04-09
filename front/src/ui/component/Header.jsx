import {useContext} from "react";
import {AppContext} from "../../core/context/context.jsx";
import {Link} from "react-router-dom";

const Header = () => {

    const{wallet, logout} = useContext(AppContext);

    return (
        <div className="navbar" style={{backgroundColor: 'blueviolet'}}>
            {
                wallet.length === 0 ?
                    <>
                        <h2> Профессионалы 2025</h2>
                        <Link to="/pool" className="btn btn-primary"> пулы</Link>
                        <Link to="/" className="btn btn-primary">войти</Link>
                    </> :
                    <>
                        <h2> Профессионалы 2025</h2>
                        <Link to="/routing" className="btn btn-primary"> обмен </Link>
                        <Link to="/staking" className="btn btn-primary"> вклад</Link>
                        <Link to="/pool" className="btn btn-primary"> пулы</Link>
                        <Link to="/" className="btn btn-primary" onClick={logout}>выйти</Link>
                        <Link to="/" className="btn btn-primary"> личный кабинет</Link>
                    </>
            }


        </div>
    )
}
export { Header }