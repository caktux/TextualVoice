TextualVoice plugin
-------------------

Installation
============
Copy `TextualVoice.bundle` (trust required) or build the XCode project and copy the bundle to:
```
~/Library/Containers/com.codeux.irc.textual/Data/Library/Application Support/Textual IRC/Extensions
```

Configuration
=============
Right-click on the bundle, and click Show Package Contents. Open `Resources/nicknames.plist` to configure which nicknames get spoken messages, in which channels, and using which voice. Enabled nicknames (only) will also use speech when your own nickname is mentioned or in private messages (this behavior is not configurable, remove lines 120 and 123 and rebuild the bundle to disable).

### Options
* Add nicknames as keys in the `nicknames.plist` file.
* Add channels as space-separated values.
* Use the string `true` to enable speech for every message from a nickname.
* You can assign different voices to different nicknames by adding `voice:tom.premium` to values, which is the last part of their corresponding Bundle identifier. Look in `/System/Library/Speech/Voices` for voice bundles, and open their `Info.plist` to find it. Omit this option to use your default system voice. **Note: You need to have the voice installed on your system to use it.**


Usage
=====
Enable speech
```
/talk on
```

Disable speech
```
/talk off
```

TODO
====
* Integrate nicknames.plist configuration to Textual preferences or as IRC commands
