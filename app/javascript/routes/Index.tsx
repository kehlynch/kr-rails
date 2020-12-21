import React from "react";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";
import ActionCable from 'actioncable';

/* eslint-disable */
// @ts-ignore
import { ActionCableProvider } from '@thrash-industries/react-actioncable-provider';
/* eslint-enable */

import PrivateRoute from "./PrivateRoute"
import Home from "../components/Home";
import Game from "../components/Game";
import Match from "../components/Match";
import Login from "../components/Login";
import Test from "../components/Test";


const cable = ActionCable.createConsumer('/channels');


export default (
  <ActionCableProvider cable={cable}>
  <Router>
    <Switch>
      <Route path="/login" exact component={Login} />
      <Route path="/test" exact component={Test} />
      <PrivateRoute path="/" exact Component={Home} />
      <PrivateRoute path="/match" exact Component={Match} />
      <PrivateRoute path="/play" exact Component={Game} />
    </Switch>
  </Router>
</ActionCableProvider>
);
