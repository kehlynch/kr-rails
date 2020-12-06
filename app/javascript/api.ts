// import Cookies from "js-cookie";
//
const apiCall = (
  path: string,
  method: string,
  body: any,
  callback?: Function
) => {
  const tokenElement = document.querySelector('meta[name="csrf-token"]');

  let token;

  if (tokenElement instanceof HTMLMetaElement) {
    token = tokenElement.content;
  }

  if (token == null) {
    return;
  }

  const url = `/api/${path}`;

  fetch(url, {
    method,
    headers: {
      "X-CSRF-Token": token,
      "Content-Type": "application/json",
    },
    body,
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => callback && callback(data));
};

export const createSession = (name: string, callback: Function): void => {
  apiCall("sessions", "POST", JSON.stringify({ name }), callback);
};

export const getPlayer = (callback: Function): void => {
  apiCall("sessions/retrieve", "GET", null, callback);
};

export const destroySession = (callback: Function): void => {
  apiCall("sessions", "DELETE", null, callback);
};

export const getOpenMatches = (callback: Function): void => {
  apiCall("matches/list_open", "GET", null, callback);
};

export const gotoLastGame = (matchId: number, callback: Function): void => {
  apiCall(`matches/${matchId}/goto_last_game`, "PUT", null, callback);
};

export const gotoMatch = (matchId: number, callback: Function): void => {
  apiCall(`matches/${matchId}/set`, "PUT", null, callback);
};

export const getGame = (callback: Function): void => {
  apiCall("games/current", "GET", null, callback);
};

export const getMatch = (callback: Function): void => {
  apiCall("matches/current", "GET", null, callback);
};

export const createMatch = (humanCount: number, callback: Function): void => {
  apiCall("matches", "POST", JSON.stringify({ humanCount }), callback);
};
