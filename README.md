Network-listener
================

This is sample app for http://apple.stackexchange.com/q/139267/74657 question.

To make it work: <ul>
<li>place: <code>.networkConnected</code> inside <code>$HOME</code> directory</li>
<li>place: <code>.networkDisconnected</code> inside <code>$HOME</code> directory</li>
<li>place: <code>Network-Listener.plist</code> inside <code>$HOME/Library/LaunchAgents/</code> directory</li>
<li>place: <code>Network Listener.app</code> inside <code>/Applications</code> directory</li>
<li>make <code>.networkConnected</code> and <code>.networkDisconnected</code> executable</li>
</ul>

Executable scripts: <ul>
<li>File <code>.networkDisconnected</code> gets the name of the disconnected network as first argument.</li>
<li>File <code>.networkConnected</code> gets the name of the connected network as second argument.</li>
<li>File <code>.networkConnected</code> gets the name of disconnected network as first argument. </li>
</ul>

NOTE: right now first argument to .networkConnected is always „NOT_CONNECTED” because between changing the network - notification about disconnection is sent to this daemon.

Credits:
Network change notifications code from http://stackoverflow.com/a/15102521/3488699
