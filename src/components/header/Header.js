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
    


    return (<>

    <Wallet saveAccount={saveAccount} saveConnected={saveConnected}/>

        <div className="header">
            <h4 className="appName">BlockSmiths Voting System</h4>
            <button className="adminButton" onClick={handleHomeClick} style={{marginFeft: "50px"}}>
                Home
            </button>
            {connected ? (
                <>
                    <button className="adminButton" onClick={handleAdminClick}>
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