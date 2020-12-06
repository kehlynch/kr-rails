import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Home from "../components/Home";
import Game from "../components/Game";
import Match from "../components/Match";
import Login from "../components/Login";

export default (
  <Router>
    <Switch>
      <Route path="/login" exact component={Login} />
      <Route path="/" exact component={Home} />
      <Route path="/match" exact component={Match} />
      <Route path="/play" exact component={Game} />
    </Switch>
  </Router>
);
