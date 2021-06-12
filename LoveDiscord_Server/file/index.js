process.title = "LoveDiscord | SERVER";

// Require modules
const Rcon    = require('rcon');
const Discord = require('discord.js')
const options = require('./CONFIG.json')

// Open the rcon connection
var rcon = new Rcon("127.0.0.1", options.port, options.password, {tcp: false,challenge: false});
var Auth = false;

rcon.on('end', function() {
  console.log("\x1b[31mX\x1b[0m Socket ended by other party!");

}).on('response', function(str) {
  if (str == "rint Invalid password.") { // Invalid password
    console.log("\x1b[31mX\x1b[0m RCON Invalid password ["+options.password+"]");
  } else if(!Auth) { // Valid password
    Auth = true;
    console.log("\x1b[32m√\x1b[0m RCON Connected ["+options.port+"]");
    StartDiscord();
  }
});

rcon.connect();
rcon.send("heartbeat"); // Send heartbeat to check if the connection was established

// Discord bot code
function StartDiscord() {
  let discord = new Discord.Client();
  discord.on("ready", () => {
    console.log("\x1b[32m√\x1b[0m BOT Connected ["+ discord.user.username +"#"+ discord.user.discriminator + "]");

    console.log("\x1b[32mEverything started successfully.\x1b[0m\n\nAuthor: \x1B[36mXenoS.єχє#2859\x1b[0m")
  });

  discord.on("message", msg => {
    if (msg.channel.id === options.channel){
      const args = msg.content.slice(options.prefix.length).trim().split(' ');
      const command = args.shift().toLowerCase();

      if (options.commands.indexOf(command) > -1) {
        rcon.send(command + " " + (args.toString()).replace(",", " "))
      }
    }
  });

  discord.login(options.token);
}