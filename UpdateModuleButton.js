import React from 'react';
import { NativeModules, Button } from 'react-native';

const { UpdateModule } = NativeModules;

const UpdateModuleButton = () => {
  const onPress = () => {
    UpdateModule.nativeUpdateLogic();
  };

  return (
    <Button
      title="Click to invoke your native module!"
      color="#841584"
      onPress={onPress}
    />
  );
};

export default UpdateModuleButton;