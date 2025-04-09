import {createContext, useState} from "react";
const AppContext = createContext({})

const AppProvider = ({ children }) => {
    const[wallet, setWallet] = useState("")

    const login = async() => {
        const accounsts = await window.ethereum.request({method:"eth_requestAccounts"})
        const walletAddress = accounsts[0]
        setWallet(walletAddress)
        console.log(walletAddress);
    }


    const logout = async () => {
        await setWallet("")
    }

    const values = {
        wallet,
        login,
        logout,
    }

    return <AppContext.Provider value={values}>{children}</AppContext.Provider>
}

export {AppProvider, AppContext}