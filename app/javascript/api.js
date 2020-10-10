// import Cookies from "js-cookie";

export const createSession = (name, callback) => {
  const url = `/api/sessions`;
  const token = document.querySelector('meta[name="csrf-token"]').content;

  fetch(url, {
    method: "POST",
    headers: {
      "X-CSRF-Token": token,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ name }),
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => callback(data));
};

export const getPlayer = (callback) => {
  const url = `/api/sessions/retrieve`;
  const token = document.querySelector('meta[name="csrf-token"]').content;

  fetch(url, {
    method: "GET",
    headers: {
      "X-CSRF-Token": token,
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => callback(data));
};

export const destroySession = (name, callback) => {
  const url = `/api/sessions/`;
  const token = document.querySelector('meta[name="csrf-token"]').content;

  fetch(url, {
    method: "DELETE",
    headers: {
      "X-CSRF-Token": token,
      "Content-Type": "application/json",
    },
  })
    .then((response) => {
      if (response.ok) {
        return response.json();
      }
      throw new Error("Network response was not ok.");
    })
    .then((data) => callback(data));
};
