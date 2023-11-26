import { useState, useEffect } from "react";
import './Header.css';
import Wallet from "../Wallet/Wallet";
import { useNavigate } from 'react-router-dom';

const Header = () => {
// *****************
    const [account, setAccount] = useState({
        account: null
    });

    const [connected, setConnected] = useState(false);

    const [state, setState] = useState({
        web: null,
        contract: null,
        accounts: null
    })
    const saveState = (state) => {
        setState(state);
    }

    const [isAdmin, setIsAdmin] = useState(false);

    const saveAccount = (account) => {
        setAccount(account);
    }

    const saveConnected = (status) => {
        setConnected(status)
    }
// *******************

    let navigate = useNavigate();

    const handleAdminClick = () => {
        navigate('/admin');
    };

    const handleHomeClick = () => {
        navigate('/')
    }

    useEffect(() => {
        const isAdmin = async () => {
            const { contract, accounts } = state
            if (!contract) {
                return;
            }
            const isAdmin = await contract.methods.checkIfAdminUser(accounts[0]).call();
            setIsAdmin(isAdmin)
        };
        isAdmin();
    }, [state]);

    return (<>

    <Wallet saveState={saveState} saveAccount={saveAccount} saveConnected={saveConnected}/>

        <div className="header">
            <h4 className="appName">BlockSmiths Voting System</h4>
            <button className="adminButton" onClick={handleHomeClick} style={{marginFeft: "50px"}}>
                Home
            </button>
            {connected ? (
                <>
                    {console.log("IsADMIN", isAdmin)}
                    <button className="adminButton" onClick={handleAdminClick} disabled={!isAdmin}>
                        Admin
                    </button>
                    <h3 className="connectStatus">Account Connected ({account[0]})</h3>
                </>
            ) : (
                <h3 className="connectStatus">Connect Account to Vote</h3>
            )}
        </div>

    </>);
};

export default Header;