import { useState } from "react";
import Wallet from "./components/Wallet/Wallet.js";
import Leaderboard from "./components/leaderboard/Leaderboard.js";
import Footer from "./components/footer/Footer.js";
import Vote from "./components/Vote/Vote.js";


const Home = () => {
    const [state, setState] = useState({
        web: null,
        contract: null,
        accounts: null
    })
    const saveState = (state) => {
        setState(state);
    }

    return (
        <>
            <div className="main">
                <Wallet saveState={saveState}></Wallet>
                <Leaderboard state={state} isAdmin={false}/>
                <Vote state={state}/>
                <Footer></Footer>
            </div>
        </>
    );
};

export default Home;