import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import Home from "../components/Home";
import Game from "../components/Game";

export default (
  <Router>
    <Switch>
      <Route path="/" exact component={Home} />
      <Route path="/play" exact component={Game} />
    </Switch>
  </Router>
);
