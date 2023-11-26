import Web3 from "web3";
import { useState, useEffect } from "react";
import ContractJSON from "../../build/contracts/VotingContract.json"


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
                        "0x28Fbd0eC06D769170f8e5e6d6bfB4727662Aa21B"
                    );
                    const accounts = await web3.eth.getAccounts();
                    saveAccount && saveAccount(accounts);
                    console.log("ACCOUNTS", accounts)
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
