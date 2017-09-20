 import processing.net.*;

Client c;
String data;
float rotAngle;
String channelName = "channelNameGoesHere"; //this is the channel you are connecting
String oAuthKey = "oAuthKeyGoesHere"; // twitch oAuth, google it...
String user;
String comment;

void setup() {
  size(200, 200);
  noStroke();
  loadTwitchAPI();
}

void loadTwitchAPI() {
  c = new Client(this, "irc.chat.twitch.tv", 6667); // Connect to server on port 80
  c.write("PASS oauth:"+oAuthKey+" \r\n");
  c.write("NICK #nickname \r\n");
  c.write("JOIN #"+channelName+" \r\n");
  //c.write("CAP REQ :twitch.tv/membership \r\n");
}

void draw() {
  background(0);
  checkChat();
}

int chatCounter;

void checkChat() {
  if (c.available() > 0) { // If there's incoming data from the client...
    data = c.readString(); // ...then grab it and print it
    if(data.contains("PING :tmi.twitch.tv")) {
      c.write("PONG :tmi.twitch.tv \r\n");
    }
    if(data.contains("PRIVMSG")){
      user = findUser(data);
      comment = findChat(data);
      println(comment);
    }
  }
}

String findChat(String messageData) {
  String chatMsg;
  try{
    chatMsg = trim(messageData.split("PRIVMSG",2)[1]).split(" ", 2)[1];
  }catch(ArrayIndexOutOfBoundsException e){
    chatMsg = "ERROR!!!!";
  }
  return chatMsg.substring(1);
}

String findUser(String messageData) {
  int start = messageData.indexOf("!")+1;
  int end = messageData.indexOf("@");
  try{
    return messageData.substring(start,end);
  }catch(StringIndexOutOfBoundsException e) {
    return "ERROR!!!";
  }
}

void sendMsg(String msg){
  c.write("PRIVMSG #"+channelName+" :"+msg+" \r\n");
}

void mousePressed() {
  sendMsg("Hello World");
}