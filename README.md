## React Native TextInput Utils (iOS only)
[![npm version](https://badge.fury.io/js/react-native-textinput-utils.svg)](https://badge.fury.io/js/react-native-textinput-utils)
[![MIT](https://img.shields.io/dub/l/vibe-d.svg)]()

A react native extendsion which allows you to control TextInput better.

The original name is [react-native-keyboard-toolbar](http://github.com/DickyT/react-native-keyboard-toolbar), because the latest add some features, I think the old name is not suitable for this package.

![react-native-textinput-utils](https://cloud.githubusercontent.com/assets/4535844/11055687/f2652524-874f-11e5-96f0-333c6bc4ba1c.gif)

## Timeline
0.2.5 - Nov. 12 2015 - Added the fully support of `multiline` `<TextInput/>

0.2.1 - Nov. 11 2015 - Added the support of `tintColor`, which can set the cursor color

0.2 - Nov. 10 2015 - Added the support of `dismissKeyboard`, `moveCursorToLast` and `setSelection`

0.1 - Nov. 9 2015 - Added the support of setting an `UIPickerView` as the `inputView`


## What can I do?

1. Adding `UITabBarItem`(s) into the keyboard of `<TextInput/>`
2. Adding a `UIPickerView` as a default keyboard of `<TextInput/>`
3. Setting the selection area or cursor using only two parameters, which are `start` and `length`

*The `PickerIOS` Component in React Native 0.13 cannot be styled well outside `NavigatorIOS`*


## Limitation
This extension does not support `<TextInput/>` with `multiline={true}`, and I need some time to figure out. If you got some idea, it will really welcome to send me a PR.

## Installation

__I am still very simple to use__

```cd``` to your React Native project directory and run

```npm install react-native-textinput-utils --save```

## How to run

### Runing the demo
Download and open the `RCTTextInputUtilsDemo.xcodeproj` file, and runs.

### Using this package in other project
You might need to add the `es7.classProperties` into your `PROJECT_ROOT/npm_modules/react-native/packager/transformer.js` and `PROJECT_ROOT/npm_modules/react-native/packager/react-packager/.babelrc`

## iOS configuration

1. In XCode, in the project navigator right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-textinput-utils` and *ADD* `RCTTextInputUtils.xcodeproj` 
3. Drag `libRCTKeyboardToolbar.a` (from 'Products' under RCTTextInputUtils.xcodeproj) into `General` ➜ `Linked Frameworks and Libraries` phase. (GIF below)
5. Run your project (`Cmd+R`)

![RCTTextInputUtilsGuide](https://cloud.githubusercontent.com/assets/4535844/11019656/9ff660dc-85d8-11e5-9823-b4437f498a77.gif)

## Basic Usage
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

### If you want a UIPickerView
```jsx
var pickerViewData = [
  {
    label: 'One',
    value: 'ValueOne'
  },
  {
    label: 'Two',
    value: 'ValueTwo'
  },
  {
    label: 'Three',
    value: 'ValueThree'
  }
];
```
```jsx
<RCTKeyboardToolbarTextInput
  pickerViewData={pickerViewData}
  onPickerSelect={(selectedIndex)=>{console.log(`selected ${selectedIndex}`)}}
  ...
/>
```

### If you want to set the cursor color
```jsx
<RCTKeyboardToolbarTextInput
  tintColor='red'
  ...
/>
```

### If you want to set the selection area
```jsx
<RCTKeyboardToolbarTextInput
  ref='reference'
  ...
/>
```
and you can call
```jsx
this.refs['reference'].setSelection(start, length);
```

#### Or you just want to simply move the cursor to the last
```jsx
this.refs['reference'].moveCursorToLast();
```

#### Or dismiss the keyboard whenever you want
```jsx
this.refs['reference'].dismissKeyboard();
```

## Configurations
The **`<TabBarNavigator/>`** object can take the following props:

### Basic Parameters
- `leftButtonText`: The text in the *left-side* `UIToolBarItem`, if this value is empty, the UIToolBarItem on the *left* side will not be created
- `rightButtonText`: The text in the *right-side* `UIToolBarItem`, if this value is empty, the UIToolBarItem on the *right* side will not be created
- `onCancel`: The callback function of *left-side* `UIToolBarItem`
- `onDone`: The callback function of *right-side* `UIToolBarItem`
- `tintColor`: The cusor color

And both `onCancel` and `onDone` will passing an function back, if you call that function, the keyboard will be dismissed.

```jsx
function onCancel_Or_onDone(dismissKeyboardFunction) {
    console.log(`I will dismiss the keyboard`);
    dismissKeyboardFunction();
}
```

### PickerView related Parameters
- `pickerViewData`: The data source of the `PickerView`, should be an `Array`, which each element is an `Object`, and the `label` in each `Object` will be display in the `PickerView`
- `onPickerSelect`: The callback function when user picks an option, will pass the `selectedIndex` back, you can use this index to reference back to your data `Array`

```jsx
function onPickerSelectCallback(selectedIndex) {
    console.log(`Selected Index is ${selectedIndex}`);
}
```

__If you set the `ref` props of this Component, you can reference it back after `constructor` is called. You can use `this.refs[YOUR_REFERENCE]` to access the Component`s related methods.__

Here is the methods
- `dismissKeyboard`: If you want to dismiss the keyboard or the `UIPickerView`, just call it.
- `moveCursorToLast`: If you want to set the cursor to the last position, just call it.
- `setSelection(start, length)`: Using this method, you can set the selection area, if the `length = 0`, the cursor will move to `start` position.

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
