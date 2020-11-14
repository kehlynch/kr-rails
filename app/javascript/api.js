// import Cookies from "js-cookie";
//
const apiCall = (path, method, body, callback) => {
  const token = document.querySelector('meta[name="csrf-token"]').content;
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
    .then((data) => callback(data));
};

export const createSession = (name, callback) => {
  apiCall("sessions", "POST", JSON.stringify({ name }), callback);
};

export const getPlayer = (callback) => {
  apiCall("sessions/retrieve", "GET", null, callback);
};

export const destroySession = (callback) => {
  apiCall("sessions", "DELETE", null, callback);
};

export const getOpenMatches = (callback) => {
  apiCall("matches/list_open", "GET", null, callback);
};

export const gotoMatch = (matchId, callback) => {
  apiCall(`matches/${matchId}/goto_last_game`, "PUT", null, callback);
};
