'use strict';

const {Component} = require('react');

const {
  TextInput,
  DeviceEventEmitter,
  View,
  Text,
  NativeModules: { KeyboardToolbar },
  processColor
} = require('react-native');

class RCTKeyboardToolbarHelper {
  static sharedInstance = new RCTKeyboardToolbarHelper();
  constructor() {
    this.counter = 0;
    this.callbackList = {};
  }
  static getUid() {
    return RCTKeyboardToolbarHelper.sharedInstance.counter++;
  }
  static setCallback(key, value) {
    RCTKeyboardToolbarHelper.sharedInstance.callbackList[key] = value;
  }
  static getCallback(key) {
    return RCTKeyboardToolbarHelper.sharedInstance.callbackList[key];
  }
  static clearCallback(key){
    delete RCTKeyboardToolbarHelper.sharedInstance.callbackList[key]
  }
}

DeviceEventEmitter.addListener(
  'keyboardToolbarDidTouchOnCancel', (currentUid) => {
    let eventHandler = RCTKeyboardToolbarHelper.getCallback(currentUid).onCancel;
    if (eventHandler) eventHandler();
  }
);

DeviceEventEmitter.addListener(
  'keyboardToolbarDidTouchOnDone', (currentUid) => {
    let eventHandler = RCTKeyboardToolbarHelper.getCallback(currentUid).onDone;
    if (eventHandler) eventHandler();
  }
);

DeviceEventEmitter.addListener(
  'keyboardPickerViewDidSelected', (data) => {
    console.log(`keyboardPickerViewDidSelected => data => ${data['selectedIndex']}`);
    var currentUid = data['currentUid'];
    var selectedIndex = data['selectedIndex'];
    let eventHandler = RCTKeyboardToolbarHelper.getCallback(currentUid).onPickerSelect;
    if (eventHandler) eventHandler(selectedIndex);
  }
);

DeviceEventEmitter.addListener(
  'keyboardDatePickerViewDidSelected', (data) => {
    console.log(`keyboardDatePickerViewDidSelected => data => ${data['selectedDate']}`);
    var currentUid = data['currentUid'];
    var selectedDate = data['selectedDate'];
    let eventHandler = RCTKeyboardToolbarHelper.getCallback(currentUid).onDateSelect;
    if (eventHandler) eventHandler(selectedDate);
  }
);

class RCTKeyboardToolbarManager {
  static configure(node, options, callbacks) {
    var reactNode = React.findNodeHandle(node);
    options.uid = RCTKeyboardToolbarHelper.getUid();
    KeyboardToolbar.configure(reactNode, options, (error, currentUid) => {
      node.uid = currentUid;
      if (!error) {
        RCTKeyboardToolbarHelper.setCallback(currentUid, {
          onCancel: callbacks.onCancel,
          onDone: callbacks.onDone,
          onPickerSelect: callbacks.onPickerSelect,
          onDateSelect: callbacks.onDateSelect
        });
      }
    });
  }
  static dismissKeyboard(node) {
    var nodeHandle = React.findNodeHandle(node);
    KeyboardToolbar.dismissKeyboard(nodeHandle);
  }
  static moveCursorToLast(node) {
    var nodeHandle = React.findNodeHandle(node);
    KeyboardToolbar.moveCursorToLast(nodeHandle);
  }
  static setSelectedTextRange(node, NSRange) {
    var nodeHandle = React.findNodeHandle(node);
    KeyboardToolbar.setSelectedTextRange(nodeHandle, NSRange);
  }
}

class RCTKeyboardToolbarTextInput extends Component {
  componentDidMount() {
    var pickerViewData = [];
    if (this.props.pickerViewData) {
      this.props.pickerViewData.map((eachData) => {
        pickerViewData.push(eachData.label);
      });
    }

    var callbacks = {
      onCancel: () => {
        // onCancel
        if (this.props.onCancel) this.props.onCancel(RCTKeyboardToolbarManager.dismissKeyboard.bind(this, this.refs['MygKD']));
      },
      onDone: () => {
        // onDone
        if (this.props.onDone) this.props.onDone(RCTKeyboardToolbarManager.dismissKeyboard.bind(this, this.refs['MygKD']));
      },
      onPickerSelect: this.props.onPickerSelect,
      onDateSelect: this.props.onDateSelect,
    };

    RCTKeyboardToolbarManager.configure(this.refs['MygKD'], {
      barStyle: this.props.barStyle,
      leftButtonText: this.props.leftButtonText,
      rightButtonText: this.props.rightButtonText,
      pickerViewData: pickerViewData,
      datePickerOptions: this.props.datePickerOptions,
      tintColor: processColor(this.props.tintColor)
    }, callbacks);
  }
  componentWillUnmount(){
    RCTKeyboardToolbarHelper.clearCallback(this.refs['MygKD'].uid);
  }
  dismissKeyboard() {
    RCTKeyboardToolbarManager.dismissKeyboard(this.refs['MygKD']);
  }
  moveCursorToLast() {
    RCTKeyboardToolbarManager.moveCursorToLast(this.refs['MygKD']);
  }
  setSelection(start, length) {
    RCTKeyboardToolbarManager.setSelectedTextRange(this.refs['MygKD'], {
      start: start,
      length: length
    });
  }
  focus(){
    this.refs.MygKD.focus();
  }
  render() {
    return (
      <TextInput
        {...this.props}
        ref='MygKD'/>
    );
  }
}

module.exports = RCTKeyboardToolbarTextInput;