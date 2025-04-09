import {AppProvider} from "../core/context/context.jsx";
import {RouterProvider} from "react-router-dom";
import router from "../core/router/router.jsx";

const App = () => {
    return (
        <>
        <AppProvider>
            <RouterProvider router={router}>

            </RouterProvider>
        </AppProvider>
        </>
    )
}

export default App;