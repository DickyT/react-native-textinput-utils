'use strict';

const React = require('react-native');

const {
  Component,
  TextInput,
  DeviceEventEmitter,
  NativeModules: { KeyboardToolbar }
} = React;

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
}

DeviceEventEmitter.addListener(
  'keyboardToolbarDidTouchOnCancel', (currentUid) => {
    RCTKeyboardToolbarHelper.getCallback(currentUid).onCancel();
  }
);

DeviceEventEmitter.addListener(
  'keyboardToolbarDidTouchOnDone', (currentUid) => {
    RCTKeyboardToolbarHelper.getCallback(currentUid).onDone();
  }
);

class RCTKeyboardToolbarManager {
  static configure(node, options, onCancel, onDone) {
    var reactNode = React.findNodeHandle(node);
    options.uid = RCTKeyboardToolbarHelper.getUid();
    KeyboardToolbar.configure(reactNode, options, (error, currentUid) => {
      if (!error) {
        RCTKeyboardToolbarHelper.setCallback(currentUid, {
          onCancel: onCancel,
          onDone: onDone
        });
      }
    });
  }
  static dismissKeyboard(node) {
    var nodeHandle = React.findNodeHandle(node);
    KeyboardToolbar.dismissKeyboard(nodeHandle);
  }
}

class RCTKeyboardToolbarTextInput extends Component {
  componentDidMount() {
    if (!this.props.multiline) {
      RCTKeyboardToolbarManager.configure(this.refs['MygKD'], {
        barStyle: this.props.barStyle,
        leftButtonText: this.props.leftButtonText,
        rightButtonText: this.props.rightButtonText
      }, () => {
        // onCancel
        this.props.onCancel(RCTKeyboardToolbarManager.dismissKeyboard.bind(this, this.refs['MygKD']));
      }, () => {
        // onDone
        this.props.onDone(RCTKeyboardToolbarManager.dismissKeyboard.bind(this, this.refs['MygKD']));
      });
    }
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