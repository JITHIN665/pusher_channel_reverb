# pusher_channel_reverb

### Deployment targets

- iOS 13.0 and above
- Android 6.0 and above
- Web Chrome/Edge/Firefox/Safari.



## Installation

To integrate the plugin in your Flutter App, you need
to add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  pusher_channel_reverb_flutter: '^1.0.1'
```


## Initialization

The PusherChannelFlutter class is a singleton, that
can be instantiated with `getInstance()`. Then you need to initialize the client with a number of configuration options, here is a quick example with a number of callbacks options:

```dart
PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
try {
  await pusher.init(
    apiKey: API_KEY,
    cluster: API_CLUSTER,
    onConnectionStateChange: onConnectionStateChange,
    onError: onError,
    onSubscriptionSucceeded: onSubscriptionSucceeded,
    onEvent: onEvent,
    onSubscriptionError: onSubscriptionError,
    onDecryptionFailure: onDecryptionFailure,
    onMemberAdded: onMemberAdded,
    onMemberRemoved: onMemberRemoved,
    // authEndpoint: "<Your Authendpoint>",
    // onAuthorizer: onAuthorizer
  );
  await pusher.subscribe(channelName: 'presence-chatbox');
  await pusher.connect();
} catch (e) {
  print("ERROR: $e");
}
```

After calling `init(...)` you can connect to the Pusher servers.
You can subscribe to channels before calling `connect()`

## Configuration

There are a number of configuration parameters which can be set for the Pusher client. The following table
describes for which platform the parameter is available:

| parameter                | Android | iOS | Web |
| ------------------------ | ------- | --- | --- |
| activityTimeout          | ✅      | ✅  | ✅  |
| apiKey                   | ✅      | ✅  | ✅  |
| authParam                | ⬜️      | ⬜️ | ✅  |
| authEndpoint             | ✅      | ✅  | ✅  |
| authTransport            | ⬜️      | ⬜️ | ✅  |
| cluster                  | ✅      | ✅  | ✅  |
| disabledTransports       | ⬜️     | ⬜️ | ✅  |
| enabledTransports        | ⬜️     | ⬜️ | ✅  |
| enableStats              | ⬜️     | ⬜️ | ✅  |
| ignoreNullOrigin         | ⬜️     | ⬜️ | ✅  |
| logToConsole             | ⬜️     | ⬜️ | ✅  |
| maxReconnectGapInSeconds | ✅      | ✅  | ⬜️ |
| maxReconnectionAttempts  | ✅      | ✅  | ⬜️ |
| pongTimeout              | ✅      | ✅  | ✅  |
| proxy                    | ✅      | ⬜️ | ⬜️ |
| useTLS                   | ✅      | ✅  | ⬜️ |

#### `activityTimeout (double)`

After this time (in seconds) without any messages received from the server, a ping message will be sent to check if the connection is still working; the default value is supplied by the server, low values will result in unnecessary traffic.

#### `apiKey (String)`

You can get your `API_KEY` and `API_CLUSTER` from the [Pusher Channels dashboard](https://dashboard.pusher.com/).

#### `authParams (Map)`

Allows passing additional data to authorizers. Supports query string params and headers (AJAX only). For example, following will pass `foo=bar` via the query string and `baz: boo` via headers:

```dart
final pusher = PusherChannelsFlutter.getInstance()
await pusher.init(
  apiKey: API_KEY,
  cluster: API_CLUSTER,
  authParams: {
    'params': { 'foo': 'bar' },
    'headers': { 'baz': 'boo' }
  }
});
```


CSRF

If you require a CSRF header for incoming requests to the private channel authentication endpoint on your server, you should add a CSRF token to the `auth` hash under `headers`. This is applicable to frameworks which apply CSRF protection by default.

```dart
final pusher = await pusher.init(
  apiKey: API_KEY,
  cluster: API_CLUSTER,
  authParams: {
    'params': { 'foo': 'bar' },
    'headers': { 'X-CSRF-Token': 'SOME_CSRF_TOKEN' }
  }
);
```

#### `useTLS (bool)`

Whether or not you'd like to use TLS encrypted transport or not, default is `true`

## Event Callback parameters

The following functions are callbacks that can be passed to the `init()` method. All are optional.

#### `onEvent`

```dart
void onEvent(PusherEvent event) {
  print("onEvent: $event");
}
```

Called when a event is received by the client.
The global event handler will trigger on events from any channel.

#### `onSubscriptionSucceeded`

```dart
void onSubscriptionSucceeded(String channelName, dynamic data) {
  print("onSubscriptionSucceeded: $channelName data: $data");
}
```

use this if you want to be informed of when a channel has successfully been subscribed to, which is useful if you want to perform actions that are only relevant after a subscription has succeeded. For example querying the members for presence channel.

#### `onSubscriptionError`

```dart
void onSubscriptionError(String message, dynamic e) {
  print("onSubscriptionError: $message Exception: $e");
}
```

use this if you want to be informed of a failed subscription attempt, which you could use, for example, to then attempt another subscription or make a call to a service you use to track errors.

#### `onDecryptionFailure`

```dart
void onDecryptionFailure(String event, String reason) {
  print("onDecryptionFailure: $event reason: $reason");
}
```

only used with private encrypted channels - use this if you want to be notified if any messages fail to decrypt.

#### `onMemberAdded`

```dart
void onMemberAdded(String channelName, PusherMember member) {
  print("onMemberAdded: $channelName member: $member");
}
```

Called when a member is added to the presence channel.

#### `onMemberRemoved`

```dart
void onMemberRemoved(String channelName, PusherMember member) {
  print("onMemberRemoved: $channelName member: $member");
}
```

Called when a member is removed to the presence channel.

#### `onAuthorizer`

When passing the `onAuthorizer()` callback to the `init()` method, this callback is called to request auth information.

```dart
dynamic onAuthorizer(String channelName, String socketId, dynamic options) async {
  return {
    "auth": "foo:bar",
    "channel_data": '{"user_id": 1}',
    "shared_secret": "foobar"
  };
}
```

#### `onConnectionStateChange`

```dart
void onConnectionStateChange(dynamic currentState, dynamic previousState) {
  print("Connection: $currentState");
}
```

use this if you want to use connection state changes to perform different actions / UI updates
The different states that the connection can be in are:

- `CONNECTING` - the connection is about to attempt to be made
- `CONNECTED` - the connection has been successfully made
- `DISCONNECTING` - the connection has been instructed to disconnect and it is just about to do so
- `DISCONNECTED` - the connection has disconnected and no attempt will be made to reconnect automatically
- `RECONNECTING` - an attempt is going to be made to try and re-establish the connection

#### `onError`

```dart
void onError(String message, int? code, dynamic e) {
  print("onError: $message code: $code exception: $e");
}
```


## Connection handling

### Connecting

To connect to the Pusher network, just call the `connect()` method.

```dart
await pusher.connect();
```

### Disconnecting

To disconnect to the Pusher network, just call the `disconnect()` method.

```dart
await pusher.disconnect();
```

### Reconnection

There are three main ways in which a disconnection can occur:

- The client explicitly calls disconnect and a close frame is sent over the websocket connection
- The client experiences some form of network degradation which leads to a heartbeat (ping/pong) message being missed and thus the client disconnects
- The Pusher server closes the websocket connection; typically this will only occur during a restart of the Pusher socket servers and an almost immediate reconnection should occur

In the case of the first type of disconnection the library will (as you'd hope) not attempt a reconnection.

## Subscribing

### Public channels

The default method for subscribing to a channel involves invoking the `subscribe` method of your client object:

```dart
final myChannel = await pusher.subscribe(channelName: "my-channel");
```

### Private channels

Private channels are created in exactly the same way as public channels, except that they reside in the 'private-' namespace. This means prefixing the channel name:

```dart
final myPrivateChannel = await pusher.subscribe(channelName: "private-my-channel")
```

Subscribing to private channels involves the client being authenticated. See the [Configuration](#configuration) section for the authenticated channel example for more information.


#### Limitations

- Client events are not supported on encrypted channels

```dart
final privateEncryptedChannel = await pusher.subscribe(channelName: "private-encrypted-my-channel")
```

There is also an optional callback in the connection delegate when you can listen for
any failed decryption events:

```dart
optional func void onDecryptionFailure(String event, String reason)
```

### Presence channels

Presence channels are channels whose names are prefixed by `presence-`.

The resulting channel object has a member: `members` that contains the active members of the channel.

```dart
final myPresenceChannel = await pusher.subscribe(channelName: "presence-my-channel")
```

You can also provide functions that will be called when members are either added to or removed from the channel. These are available as parameters to `init()` globally, or to `subscribe()` per channel.

```dart
void onMemberAdded(String channelName, PusherMember member) {
  print("onMemberAdded: $channelName user: $member");
}
```

```dart
void onMemberRemoved(String channelName, PusherMember member) {
  print("onMemberRemoved: $channelName user: $member");
}
```

**Note**: The `members` property of `PusherChannel` objects will only be set once subscription to the channel has succeeded.

The easiest way to find out when a channel has been successfully subscribed to is to bind to the callback named `onSubscriptionSucceeded` on the channel you're interested in. It would look something like this:

```dart
final pusher = PusherChannelsFlutter.getInstance();
final channels = {};
await pusher.init(
  apiKey: API_KEY,
  cluster: API_CLUSTER,
  authEndPoint: "https://your-server.com/auth"
);
final myChannel = await pusher.subscribe(
  channelName:'presence-my-channel',
  onSubscriptionSucceeded: (channelName, data) {
    print("Subscribed to $channelName");
    print("I can now access me: ${myChannel.me}")
    print("And here are the channel members: ${myChannel.members}")
  },
  onMemberAdded: (member) {
    print("Member added: $member");
  },
  onMemberRemoved: (member) {
    print("Member removed: $member");
  },
  onEvent: (event) {
    print("Event received: $event");
  },
);
```

Note that both private and presence channels require the user to be authenticated in order to subscribe to the channel. This authentication can either happen inside the library, if you configured your Pusher object with your app's secret, or an authentication request is made to an authentication endpoint that you provide, again when initializing your Pusher object.

We recommend that you use an authentication endpoint over including your app's secret in your app in the vast majority of use cases. If you are completely certain that there's no risk to you including your app's secret in your app, for example if your app is just for internal use at your company, then it can make things easier than setting up an authentication endpoint.

### Unsubscribing

To unsubscribe from a channel, call the `unsubscribe()` method:

```dart
await pusher.unsubscribe("my-channel");
```

## Binding to events

Events can be bound to at 2 levels; globally and per channel. There is an example of this below.

### Per-channel events

These are bound to a specific channel, and mean that you can reuse event names in different parts of your client application.

```dart
final pusher = PusherChannelsFlutter.getInstance();
await pusher.init(
  apiKey: API_KEY,
  cluster: API_CLUSTER
);
final myChannel = await pusher.subscribe(
  channelName: "my-channel",
  onEvent: (event) {
    print("Got channel event: $event");
  }
);
await pusher.connect();
```

### Global events

You can attach behavior to these events regardless of the channel the event is broadcast to.

```dart
final pusher = PusherChannelsFlutter.getInstance();
await pusher.init(
  apiKey: API_KEY,
  cluster: API_CLUSTER,
  onEvent: (event) {
    print("Got event: $event");
  }
);
final myChannel = await pusher.subscribe(
  channelName: "my-channel"
);
```

### PusherEvent

The callbacks you bind receive a `PusherEvent`:

```dart
class PusherEvent {
  String channelName; // Name of the channel.
  String eventName; // Name of the event.
  dynamic data; // Data, usually JSON string. See [parsing event data](#parsing-event-data).
  String? userId; // UserId of the sending event, only for client events on presence channels.
}
```

#### Parsing event data

The `data` property of [`PusherEvent`](#pusherevent) contains the string representation of the data that you passed when you triggered the event. If you passed an object then that object will have been serialized to JSON. You can parse that JSON as appropriate.

### Receiving errors

Errors received from Pusher Channels can be accessed via the `onError` callback.

```dart
void onError(String message, int? code, dynamic e) {
  print("onError: $message code: $code exception: $e");
}
```


## Get a channel by name

To get the `PusherChannel` instance from the `Pusher` instance you can use the `getChannel(<channelName>)` method:

```dart
final channel = pusher.getChannel("presence-channel");
```

## Socket information

To get information from the current socket call the `getSocketId()` method:

```dart
final socketId = await pusher.getSocketId();
```


## License

PusherChannelsFlutter is released under the MIT license. See [LICENSE](https://github.com/JITHIN665/pusher_channel_reverb/blob/main/LICENSE) for details.