Network-listener
================

This is sample app for http://apple.stackexchange.com/q/139267/74657 question.

To make it work: <ul>
<li>place: .networkConnected inside $HOME directory</li>
<li>place: .networkDisconnected inside $HOME directory</li>
<li>place: Network-Listener.plist inside $HOME/Library/LaunchAgents/ directory</li>
<li>place: Network Listener.app inside $HOME/Documents directory</li>
<li>make .networkConnected and .networkDisconnected executable</li>
</ul>

Executable scripts: <ul>
<li>File .networkDisconnected gets the name of the disconnected network as first argument.</li>
<li>File .networkConnected gets the name of the connected network as second argument.</li>
<li>File .networkConnected gets the name of disconnected network as first argument. </li>
</ul>

NOTE: right now first argument to .networkConnected is always „NOT_CONNECTED” because between changing the network notification about disconnection is sent to this daemon.

  

Network change notificaitons code from http://stackoverflow.com/a/15102521/3488699
