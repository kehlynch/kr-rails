import React from "react";
import Nav from "react-bootstrap/Nav";
import Navbar from "react-bootstrap/Navbar";
import NavDropdown from "react-bootstrap/NavDropdown";
import { PlayerType } from "../types";

type NavBarProps = {
  player: PlayerType,
};


const NavBar = ({ player }: NavBarProps): React.ReactElement => {
  return (
    <Navbar expand="lg" variant="light" bg="light">
      <Navbar.Toggle aria-controls="responsive-navbar-nav" />
      <Nav className="mr-auto">
        <NavDropdown title="Königsrufen" id="collasible-nav-dropdown">
          <NavDropdown.Item href="/about">about</NavDropdown.Item>
        </NavDropdown>
      </Nav>
      <Navbar.Collapse className="justify-content-end">
        {player && (
          <Navbar.Text>
            Signed in as: <b>{player.name}</b>
          </Navbar.Text>
        )}
      </Navbar.Collapse>
    </Navbar>
  );
};
export default NavBar;
