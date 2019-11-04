/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/packs/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/application.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/application.js":
/*!*********************************************!*\
  !*** ./app/javascript/packs/application.js ***!
  \*********************************************/
/*! no static exports found */
/***/ (function(module, exports) {

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require_tree ./channels
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//
console.log('Hello World from Webpacker');

function submitGame(checkbox) {
  console.log("submitGame");
  console.log("checkbox", checkbox);

  if (checkbox) {
    checkbox.checked = true;
  }

  document.getElementById('gameForm').submit();
}

function toggleCard(checkbox) {
  console.log("toggleCard", checkbox);
  checkbox.checked = !checkbox.checked;
  checkbox.nextElementSibling.classList.toggle('selected');
  var selected = document.querySelectorAll('input[type="checkbox"]:checked').length;
  var submitButton = document.getElementById('talon-submit');
  console.log(stage());
  console.log(selected);

  if (stage() == 'resolve_talon') {
    submitButton.disabled = selected != 3;
  } else if (stage() == 'resolve_whole_talon') {
    submitButton.disabled = selected != 6;
  }
}

function toggleAnnouncement(checkbox) {
  if (checkbox.id == 'pass') {
    document.querySelectorAll('input[type="checkbox"]:checked').forEach(function (checkbox) {
      checkbox.checked = false;
      checkbox.nextElementSibling.classList.toggle('active');
    });
  } else {
    var passCheckbox = document.getElementById('pass');
    passCheckbox.checked = false;
    passCheckbox.nextElementSibling.classList.remove('active');
  }

  checkbox.checked = !checkbox.checked;
  checkbox.nextElementSibling.classList.toggle('active');
  var submitButton = document.getElementById('announcements-submit');
  var selected = document.querySelectorAll('input[type="checkbox"]:checked').length;

  if (stage() == 'make_announcement') {
    var birdBidNeeded = bidSlug() == 'besser_rufer' && activeBirdBids() == 0;
    var disabled = selected == 0 || birdBidNeeded;
    submitButton.disabled = disabled;
  }
}

function activeBirdBids() {
  var birds = ["pagat", "uhu", "kakadu"];
  var selected = Array.from(document.querySelectorAll('input[type="checkbox"]:checked')).filter(function (checkbox) {
    return birds.includes(checkbox.value);
  });
  return selected.length;
}

function showScores() {
  console.log("showScores");
  document.getElementById('js-trick-container').style.display = 'none';
  document.getElementById('js-score-container').style.display = 'block';
  document.getElementById('js-points-container').style.display = 'none';
}

function showPoints() {
  console.log("showPoints");
  document.getElementById('js-trick-container').style.display = 'none';
  document.getElementById('js-score-container').style.display = 'none';
  document.getElementById('js-points-container').style.display = 'block';
}

function stage() {
  var element = stageElement(); // console.log('element', element);

  return element && element.dataset.stage;
}

function bidSlug() {
  var element = stageElement();
  var bidSlug = element && element.dataset.bidSlug;
  return bidSlug;
}

function humanPlayer() {
  var element = stageElement();
  var humanPlayer = element && element.dataset.humanPlayer;
  return humanPlayer;
}

function stageElement() {
  return document.getElementById('js-stage');
}

function attachClickers() {
  document.onclick = pageClicked;
}

function pageClicked() {
  console.log("pageClicked()");
  var gameStage = stage();
  console.log(gameStage);
  console.log(humanPlayer());

  if (gameStage == 'next_trick' || gameStage == 'pick_whole_talon') {
    document.getElementById('gameForm').submit(); // } else if ( gameStage == 'finished') {
    //   showScores();
  } else if (humanPlayer() == 'false') {
    console.log('here');

    if (gameStage == 'pick_talon' || gameStage == 'resolve_talon' || gameStage == 'pick_king' || gameStage == 'make_bid' || gameStage == 'play_card' || gameStage == 'make_announcement') {
      document.getElementById('gameForm').submit();
    }
  }
} // function openConnection() {
//   return new WebSocket("ws:://localhost:3000/cable")
// }
// document.addEventListener("DOMContentLoaded", () => {
//   const webSocket = openConnection();
//   webSocket.onOpen = (event) => {
//   }
// })


attachClickers();

/***/ })

/******/ });
//# sourceMappingURL=application-0e64277ebae737b7d314.js.map