import { useState, useEffect } from "react";
import './Leaderboard.css'; 
import CandidatesData from "../candidates/Candidatesdata.js";

const Leaderboard = (props) => {

    const [candidates, setCandidates] = useState([]);

    const saveCandidates= (arr) => {
        setCandidates(arr);
    }

    return (
        <>
        <CandidatesData saveCandidates={saveCandidates} refreshKey={props.refreshKey}/>
        
            <div className="body">
                <div className="table">
                    <div className="table_header">
                        <h1>Candidates List</h1>
                    </div>
                    <div className="table_body">
                        <table>
                            <thead>
                                <tr>
                                    <th>Id</th>
                                    <th>Candidate Name</th>
                                    {
                                        (props.isAdmin) ? <th>Votes</th> : <></>
                                    }
                                </tr>
                            </thead>
                            <tbody>
                                {candidates.map((candidate) => (
                                    <tr key={candidate.id}>
                                        <td>{candidate.id}</td>
                                        <td>{candidate.name}</td>
                                        {
                                            (props.isAdmin) ? <td><strong>{candidate.voteCount}</strong></td> : <></>
                                        }
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </>
    );
};

export default Leaderboard;