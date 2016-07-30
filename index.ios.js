'use strict';

const React = require('react');

const {findNodeHandle, TextInput, DeviceEventEmitter, NativeModules: {
        KeyboardToolbar
    }, processColor} = require('react-native');

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
    static clearCallback(key) {
        delete RCTKeyboardToolbarHelper.sharedInstance.callbackList[key];
    }
}

DeviceEventEmitter.addListener('keyboardToolbarDidTouchOnCancel', (currentUid) => {
    let eventHandler = RCTKeyboardToolbarHelper.getCallback(currentUid).onCancel;
    if (eventHandler) {
        eventHandler();
    }
});

DeviceEventEmitter.addListener('keyboardToolbarDidTouchOnDone', (currentUid) => {
    let eventHandler = RCTKeyboardToolbarHelper.getCallback(currentUid).onDone;
    if (eventHandler) {
        eventHandler();
    }
});

DeviceEventEmitter.addListener('keyboardPickerViewDidSelected', (data) => {
    console.log(`keyboardPickerViewDidSelected => data => ${data['selectedIndex']}`);
    var currentUid = data['currentUid'];
    var selectedIndex = data['selectedIndex'];
    let eventHandler = RCTKeyboardToolbarHelper.getCallback(currentUid).onPickerSelect;
    if (eventHandler) {
        eventHandler(selectedIndex);
    }
});

DeviceEventEmitter.addListener('keyboardDatePickerViewDidSelected', (data) => {
    console.log(`keyboardDatePickerViewDidSelected => data => ${data['selectedDate']}`);
    var currentUid = data['currentUid'];
    var selectedDate = data['selectedDate'];
    let eventHandler = RCTKeyboardToolbarHelper.getCallback(currentUid).onDateSelect;
    if (eventHandler) {
        eventHandler(selectedDate);
    }
});

class RCTKeyboardToolbarManager {
    static configure(node, options, callbacks) {
        var reactNode = findNodeHandle(node);
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
        var nodeHandle = findNodeHandle(node);
        KeyboardToolbar.dismissKeyboard(nodeHandle);
    }
    static moveCursorToLast(node) {
        var nodeHandle = findNodeHandle(node);
        KeyboardToolbar.moveCursorToLast(nodeHandle);
    }
    static setSelectedTextRange(node, NSRange) {
        var nodeHandle = findNodeHandle(node);
        KeyboardToolbar.setSelectedTextRange(nodeHandle, NSRange);
    }
    static setDate(node, NSDate) {
        var nodeHandle = React.findNodeHandle(node);
        KeyboardToolbar.setDate(nodeHandle, NSDate);
    }
}

class RCTKeyboardToolbarTextInput extends React.Component {
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
                if (this.props.onCancel) {
                    this.props.onCancel(RCTKeyboardToolbarManager.dismissKeyboard.bind(this, this.refs.input));
                }
            },
            onDone: () => {
                // onDone
                if (this.props.onDone) {
                    this.props.onDone(RCTKeyboardToolbarManager.dismissKeyboard.bind(this, this.refs.input));
                }
            },
            onPickerSelect: this.props.onPickerSelect,
            onDateSelect: this.props.onDateSelect
        };

        RCTKeyboardToolbarManager.configure(this.refs.input, {
            barStyle: this.props.barStyle,
            leftButtonText: this.props.leftButtonText,
            rightButtonText: this.props.rightButtonText,
            pickerViewData: pickerViewData,
            datePickerOptions: this.props.datePickerOptions,
            tintColor: processColor(this.props.tintColor)
        }, callbacks);
    }
    componentWillUnmount() {
        RCTKeyboardToolbarHelper.clearCallback(this.refs.input.uid);
    }
    dismissKeyboard() {
        RCTKeyboardToolbarManager.dismissKeyboard(this.refs.input);
    }
    moveCursorToLast() {
        RCTKeyboardToolbarManager.moveCursorToLast(this.refs.input);
    }
    setSelection(start, length) {
        RCTKeyboardToolbarManager.setSelectedTextRange(this.refs.input, {
            start: start,
            length: length
        });
    }
    setDate(date) {
        RCTKeyboardToolbarManager.setDate(this.refs.input, {
            date: date
        });
    }
    focus() {
        this.refs.MygKD.focus();
    }
    render() {
        return (<TextInput {...this.props} ref="input"/>);
    }
}

module.exports = RCTKeyboardToolbarTextInput;