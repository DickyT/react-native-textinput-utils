## React Native Keyboard Toolbar (iOS only)
[![npm version](https://badge.fury.io/js/react-native-keyboard-toolbar.svg)](https://badge.fury.io/js/react-native-keyboard-toolbar)
[![MIT](https://img.shields.io/dub/l/vibe-d.svg)]()

A react native extendsion which allows you to add UIBarButtonItems to the keyboard of TextInput.

![react-native-keyboard-toolbar](https://cloud.githubusercontent.com/assets/4535844/11019638/ad4b0586-85d7-11e5-84ad-b187636d21da.gif)

## Limitation
This extension does not support `<TextInput/>` with `multiline={true}`, because the `RCTTextView` set the `inputAccessoryView` as read-only, and I need some time to figure out. If you got some idea, it will really welcome to send me a PR.

## Installation

__I am still very simple to use__

```cd``` to your React Native project directory and run

```npm install react-native-keyboard-toolbar --save```

## iOS configuration

1. In XCode, in the project navigator right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-keyboard-toolbar` and *ADD* `RCTKeyboardToolbar.xcodeproj` 
3. Drag `libRCTKeyboardToolbar.a` (from 'Products' under RCTKeyboardToolbar.xcodeproj) into `General` ➜ `Linked Frameworks and Libraries` phase. (GIF below)
5. Run your project (`Cmd+R`)

![react-native-keyboard-toolbar-guide](https://cloud.githubusercontent.com/assets/4535844/11019656/9ff660dc-85d8-11e5-9823-b4437f498a77.gif)

## Usage
```jsx
import ToolbarInput from 'react-native-keyboard-toolbar';
```

```jsx
<RCTKeyboardToolbarTextInput
  leftButtonText='I_AM_CANCEL_BUTTON'
  rightButtonText='I_AM_DONE_BUTTON'
  onCancel={(dismissKeyboard)=>dismissKeyboard()}
  onDone={(dismissKeyboard)=>dismissKeyboard()}
/>
```

## Configurations
The **`<TabBarNavigator/>`** object can take the following props:
- `leftButtonText`: The text in the *left-side* `UIToolBarItem`, if this value is empty, the UIToolBarItem on the *left* side will not be created
- `rightButtonText`: The text in the *right-side* `UIToolBarItem`, if this value is empty, the UIToolBarItem on the *right* side will not be created
- `onCancel`: The callback function of *left-side* `UIToolBarItem`
- `onDone`: The callback function of *right-side* `UIToolBarItem`

And both `onCancel` and `onDone` will passing an function back, if you call that function, the keyboard will be dismissed.

```jsx
function callbackFunction(dismissKeyboardFunction) {
    console.log(`I will dismiss the keyboard`);
    dismissKeyboardFunction();
}
```

Questions
--------------
If something is undocumented here, and it is not clear with you, feel free to create an issue here, I will tried my best to answer you.

Anything else
--------------
Feel free to request new features, just create an issue.
It will be very welcome to pull request for me.

My email ```me@idickyt.com```

Facebook [Dicky Tsang](https://www.facebook.com/idickytsang)

Sina Weibo ```@桐乃```
