// For testing
// var evt = {
// 	title: "hello",
// 	message: "world",
// 	buttontext1: "star",
// 	buttonlink1: "about.com"
// };
//
// console.log("hello");
// doNotify(evt);

// Window initialization code. Set up the various event handlers
window.addEventListener("load", function() {
	// set up the event listeners
	chrome.notifications.onClosed.addListener(notificationClosed);
	chrome.notifications.onClicked.addListener(notificationClicked);
	chrome.notifications.onButtonClicked.addListener(notificationBtnClick);
});

var buttonLinkMap = {}
// Create the notification with the given parameters as they are set in the UI
function doNotify(evt) {
	var notID = 0;
	var options = {
		type: "basic",
		title: "null1",
		message: "null2",
		imageUrl: null,
		iconUrl: "images/inbox-64x64.png",
		buttons: []
	};

	options.type = "basic";
	options.title = evt.from;
	options.message = evt.title;

  if (evt.imageUrl) {
    options.iconUrl = evt.imageUrl;
  }

	if (evt.prettyImage) {
			options.type = "image";
      options.imageUrl = evt.prettyImage;
			// options.imageUrl = chrome.runtime.getURL("/images/oceania-400x400.png");
	}
	window.buttonLinkMap = {};
	options.buttons.push(createButton(notID.toString() + 0, evt.buttons[0].buttonText, evt.buttons[0].link));
	if (evt.buttons[1]){
		options.buttons.push(createButton(notID.toString() + 1, evt.buttons[1].buttonText, evt.buttons[1].link));
	}

	options.priority = 2;

	chrome.notifications.create("id"+notID++, options, creationCallback);
  notID++;
}

function createButton(buttonID, text, link){
	var button = {
		title: text
	};
	if (text == "star") {
		console.log("HERO")
		button["iconUrl"] = "/images/star-01.png";
	}
	window.buttonLinkMap["id" + buttonID] = link;
	return button;
}

function creationCallback(notID) {
	console.log("Succesfully created ");
	setTimeout(function() {
		chrome.notifications.clear(notID, function(wasCleared) {
			console.log("Notification " + notID + " cleared: " + wasCleared);
		});
	}, 20000);
}

// Event handlers for the various notification events
function notificationClosed(notID, bByUser) {
	console.log("The notification '" + notID + "' was closed" + (bByUser ? " by the user" : ""));
}

function notificationClicked(notID) {
	console.log("The notification '" + notID + "' was clicked");
}

function notificationBtnClick(notID, iBtn) {
  console.log(buttonLinkMap);
  console.log(iBtn);
  console.log(buttonLinkMap[notID+iBtn]);
  chrome.tabs.create({url: buttonLinkMap[notID+iBtn]});
	console.log("The notification '" + notID + "' had button " + iBtn + " clicked");
}

window.onmessage=function(e){
  if (e.data) {
    console.log('I got data in my chrome extenssion', e.data);
    var data = JSON.parse(e.data);
    if (Date.now() - data.timeStamp < 1000000){
      doNotify(data);
    }
  }
}
