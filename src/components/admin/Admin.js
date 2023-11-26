import React from 'react';
import { useState } from "react";
import Leaderboard from '../leaderboard/Leaderboard';
import Wallet from '../Wallet/Wallet';
import UpdateCandi from '../updateCandidate/UpdateCandi';
import "./Admin.css"
import Footer from '../footer/Footer';


const Admin = () => {

    const [state, setState] = useState({
        web: null,
        contract: null,
        accounts: null
    })
    const saveState = (state) => {
        setState(state);
    }

    const [refreshKey, setRefreshKey] = useState(0);
    const refreshCandidateList = () => {
        setRefreshKey(oldKey => oldKey + 1);
    };

    return (
        <>
            <Wallet saveState={saveState}></Wallet>
            <h4 className='adminHeading'>Admin Panel</h4>
            <UpdateCandi state={state} refreshCandidateList={refreshCandidateList}></UpdateCandi>
            <Leaderboard state={state} isAdminPage={true} refreshKey={refreshKey}></Leaderboard>
            <Footer></Footer>
        </>
    );




};

export default Admin;