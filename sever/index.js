const express = require('express');
const { createServer } = require("http");
const { Server } = require("socket.io");

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

app.route("/").get((req, res) => {
    res.send("Socket.io server is up and running!");
});

io.on("connection", (socket) => {
    socket.join("anomynous_group");
    console.log("server connected");
    socket.on("sendMsg", (msg) => {
        console.log("here is msg:", msg);
       // socket.emit("sendMsgServer",{...mgs, type:"otherMsg"})
       io.to("anomynous_group").emit("sendMsg",{...msg, type:"otherMsg"});
        // Handle the message as needed
    })

    //socket.on("disconnect", () => {
        console.log("A user disconnected");
    //});
});

httpServer.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
  });