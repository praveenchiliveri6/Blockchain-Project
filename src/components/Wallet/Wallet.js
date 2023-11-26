import Web3 from "web3";
import { useState, useEffect } from "react";
import ContractJSON from "./Contract.json"


const Wallet = ({ saveState, saveAccount, saveConnected}) => {
    useEffect(() => {

        const connectWallet = async () => {
            try {
                const { ethereum } = window;

                if (ethereum) {

                    window.ethereum.on("chainChanged", () => {
                        window.location.reload();
                    });

                    window.ethereum.on("accountsChanged", () => {
                        window.location.reload();
                    });

                    const ABI = ContractJSON.abi;
                    const web3 = new Web3(window.ethereum);
                    await window.ethereum.request({ method: 'eth_requestAccounts' });
                    const contract = new web3.eth.Contract(
                        ABI,
                        "0xB83d626e8B4e2a53891a8e5070Ad87cdc6C09394"
                    );
                    const accounts = await web3.eth.getAccounts();
                    saveAccount && saveAccount(accounts);
                    saveConnected && saveConnected(true);
                    saveState && saveState({ web3: web3, contract: contract, accounts: accounts });

                } else {
                    alert("Please Install Metamask To Interact With This Application!");
                }

            } catch (error) {
                console.log(error);
            }
        };

        connectWallet();
    }, []); 

    return (
        <>
        </>
    )
};

export default Wallet;
