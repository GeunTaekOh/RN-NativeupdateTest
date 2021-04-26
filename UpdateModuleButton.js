import React from 'react';
import { NativeModules, Button, Alert } from 'react-native';

const { UpdateModule } = NativeModules;

const UpdateModuleButton = () => {
  const onPress = () => {
    Alert.alert(                    // 말그대로 Alert를 띄운다
      "업데이트",                    // 첫번째 text: 타이틀 제목
      "새로운 버전의 APP이 존재합니다.",                         // 두번째 text: 그 밑에 작은 제목
      [                              // 버튼 배열
        {
          text: "취소",                              // 버튼 제목
          onPress: () => console.log ("click no"),     //onPress 이벤트시 콘솔창에 로그를 찍는다
          style: "cancel"
        },
        { text: "설치", onPress: () => UpdateModule.nativeUpdateLogic() }, //버튼 제목
                                                               // 이벤트 발생시 로그를 찍는다
      ],
      { cancelable: false }
    );
    //UpdateModule.nativeUpdateLogic();
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