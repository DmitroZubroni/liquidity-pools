import {createBrowserRouter} from "react-router-dom";
import Personal from "../../ui/pages/Personak.jsx";
import Routing from "../../ui/pages/Routing.jsx";
import Staking from "../../ui/pages/Staking.jsx";
import Pool from "../../ui/pages/Pool.jsx";

const routes = [

    {
        path: "/",
        element: <Personal />,
    },

    {
        path: "/routing",
        element: <Routing/>,
    },

    {
        path: "/pool",
        element: <Pool/>,
    },

    {
        path: "/staking",
        element: <Staking/>,
    }
]

const router = createBrowserRouter(routes)
export default router