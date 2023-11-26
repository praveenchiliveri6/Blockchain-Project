import Home from "./Home.js";
import Admin from "./components/admin/Admin.js";
import Header from "./components/header/Header.js"
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

function App({ }) {

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