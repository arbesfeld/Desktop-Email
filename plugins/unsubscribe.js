function(emailJson) {
  var link = "";
  for (h in emailJson.payload.headers){
    header = emailJson.payload.headers[h]
    if (header.name == "List-unsubscribe"){
        link = header.value;
    }
  }
  var match = (link != "")
  return {match: match,
    button-text: "Unsubscribe from this email:",
    link: link
  }
};
