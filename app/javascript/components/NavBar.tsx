import React, { useState } from "react";
import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";
import NavDropdown from "react-bootstrap/NavDropdown";
import { Redirect } from "react-router-dom";

import { PlayerType } from "../types";
import { destroySession } from "../api";

type NavBarProps = {
  player: PlayerType | null,
};


const NavBar = ({ player }: NavBarProps): React.ReactElement => {
  const [loggedOut, setLoggedOut] = useState(false);

  const logout = () => {
    destroySession(() => setLoggedOut(true))
  }

  if (loggedOut) {
    return <Redirect to="/login"/>
  }
  return (
    <Navbar>
      <Navbar.Brand href="/">Königsrufen</Navbar.Brand>
      <Navbar.Toggle />
      <Navbar.Collapse>
        <Nav>
          <Nav.Link href="/about">About</Nav.Link>
        </Nav>
      </Navbar.Collapse>
      {player && (
        <Navbar.Collapse className="justify-content-end">
          <Nav>
            <NavDropdown title={`Signed in as ${player.name}`} id="basic-nav-dropdown">
              <NavDropdown.Item onClick={logout}>Log out</NavDropdown.Item>
            </NavDropdown>
          </Nav>
        </Navbar.Collapse>
      )}
    </Navbar>
  );
};
export default NavBar;
