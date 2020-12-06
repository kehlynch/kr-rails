import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";

import PrivateRoute from "./PrivateRoute"
import Home from "../components/Home";
import Game from "../components/Game";
import Match from "../components/Match";
import Login from "../components/Login";

export default (
  <Router>
    <Switch>
      <Route path="/login" exact component={Login} />
      <PrivateRoute path="/" exact Component={Home} />
      <PrivateRoute path="/match" exact Component={Match} />
      <PrivateRoute path="/play" exact Component={Game} />
    </Switch>
  </Router>
);
