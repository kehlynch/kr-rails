import React, { useState, useEffect, useCallback } from "react";
import { Route, Redirect, RouteProps } from "react-router-dom";

import { getPlayer } from "../api";
import { PlayerType } from "../types";

export interface PrivateRouteProps extends RouteProps {
  Component: React.ComponentType<any>;
}

export const PrivateRoute: React.FC<PrivateRouteProps> = ({ Component, ...rest}: PrivateRouteProps) => {

  const [[player, playerChecked], setPlayerStatus] = useState<[PlayerType | null, boolean]>([null, false]);
  const setPlayer = useCallback((p) => setPlayerStatus([p, true]), [
    setPlayerStatus,
  ]);
  useEffect(() => {
    if (!playerChecked) { getPlayer(setPlayer) }
  }, [setPlayer, playerChecked]);


  if (playerChecked && !player) {
    const renderComponent = () => <Redirect to={{ pathname: '/login' }} />;
    return <Route {...rest} component={renderComponent} render={undefined} />;
  }

  return <Route {...rest} render={(props) => <Component {...props} player={player} />} />
};

export default PrivateRoute;
