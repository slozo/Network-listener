Network-listener
================

This is sample app for http://apple.stackexchange.com/q/139267/74657 question.

To make it work:
place: .networkConnected inside $HOME directory
place: .networkDisconnected inside $HOME directory
place: Network-Listener.plist inside $HOME/Library/LaunchAgents/ directory
place: Network Listener.app inside $HOME/Documents directory
make .networkConnected and .networkDisconnected executable

File .networkDisconnected gets the name of the disconnected network as first argument.
File .networkConnected gets the name of the connected network as second argument.
File .networkConnected gets the name of disconnected network as first argument. 

NOTE: right now first argument to .networkConnected is always „NOT_CONNECTED” because between changing the network notification about disconnection is sent to this daemon.

  

Network change notificaitons code from http://stackoverflow.com/a/15102521/3488699
