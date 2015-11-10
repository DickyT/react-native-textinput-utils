/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Component,
  TouchableOpacity,
  AlertIOS
} = React;

var RCTKeyboardToolbarTextInput = require('react-native-textinput-utils');

class RCTTextInputUtilsDemo extends Component {
  constructor() {
    super();
    this.state = {
      color: 'rgba(0,0,0,.8)',
      textTwoValue: 'TEXT_2_WE_ARE_LONG'
    }
  }
  dismissKeyboard() {
    this.refs['testref'].dismissKeyboard();
  }
  moveCursorToLast() {
    this.refs['testref'].moveCursorToLast();
  }
  setSelection(start, length) {
    this.refs['testref'].setSelection(start, length);
  }
  render() {
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
    return (
      <View style={{flex: 1, backgroundColor: this.state.color, justifyContent: 'center'}}>
        <TouchableOpacity
          onPress={()=>this.setSelection(2, 3)}
          style={{marginLeft: 100, marginRight: 100, height: 50, backgroundColor: 'ffffff', marginTop: -250, marginBottom: 10}}>
          <Text style={{flex: 1, color: '000000', marginTop: 17}}>setSelection(2, 3)</Text>
        </TouchableOpacity>
        <TouchableOpacity
          onPress={()=>this.setSelection(1, 8)}
          style={{marginLeft: 100, marginRight: 100, height: 50, backgroundColor: 'ffffff', marginBottom: 10}}>
          <Text style={{flex: 1, color: '000000', marginTop: 17}}>setSelection(1, 8)</Text>
        </TouchableOpacity>
        <TouchableOpacity
          onPress={()=>this.dismissKeyboard()}
          style={{marginLeft: 100, marginRight: 100, height: 50, backgroundColor: 'ffffff', marginBottom: 50}}>
          <Text style={{flex: 1, color: '000000', marginTop: 17}}>dismissKeyboard</Text>
        </TouchableOpacity>
        <RCTKeyboardToolbarTextInput
          keyboardType='numeric'
          style={{padding: 10, height: 50, backgroundColor: 'ffffff', marginLeft: 50, marginRight: 50}}
          value={'TEXT_1_WE_ARE_LONG'} onCancel={()=>AlertIOS.alert('Clicked the TEXT_1_INPUT CANCEL Button')} onDodne={(close)=>{close();}} leftButtonText='CANCEL' rightButtonText='DONE'/>
        <RCTKeyboardToolbarTextInput
          ref='testref'
          pickerViewData={pickerViewData}
          onPickerSelect={(selectedIndex)=>{this.setState({textTwoValue: pickerViewData[selectedIndex].value});this.moveCursorToLast();}}
          keyboardType='numeric'
          style={{padding: 10, height: 50, backgroundColor: 'ffffff', marginLeft: 50, marginRight: 50}}
          value={this.state.textTwoValue} onCancel={()=>{AlertIOS.alert('Clicked the TEXT_2_INPUT SEE_THE Button');this.setState({color:'orange'})}} onDone={(close)=>{close();this.setState({color:'darkblue'});}} leftButtonText='SEE_THE' rightButtonText='MAGIC'/>
      </View>
    );
  }
}

AppRegistry.registerComponent('RCTTextInputUtilsDemo', () => RCTTextInputUtilsDemo);
