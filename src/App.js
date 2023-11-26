import Home from "./Home.js";
import Admin from "./components/admin/Admin.js";
import Header from "./components/header/Header.js"
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

function App({ }) {

  const admin = "0x76D81132eb074d4d2277fB10FdF14177fBFA7341";

  return (
    <Router>
      <Header />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/admin" element={<Admin />} />
      </Routes>
    </Router>
  );
}

export default App;