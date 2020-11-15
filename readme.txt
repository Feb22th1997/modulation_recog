_______________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
reshape_3 (Reshape)          (None, 2, 128, 1)         0         
_________________________________________________________________
zero_padding2d_3 (ZeroPaddin (None, 2, 132, 1)         0         
_________________________________________________________________
conv1 (Conv2D)               (None, 2, 130, 128)       512       
_________________________________________________________________
dropout_3 (Dropout)          (None, 2, 130, 128)       0         
_________________________________________________________________
zero_padding2d_4 (ZeroPaddin (None, 2, 134, 128)       0         
_________________________________________________________________
conv2 (Conv2D)               (None, 1, 132, 32)        24608     
_________________________________________________________________
dropout_4 (Dropout)          (None, 1, 132, 32)        0         
_________________________________________________________________
reshape_4 (Reshape)          (None, 132, 32)           0         
_________________________________________________________________
lstm_2 (LSTM)                (None, 128)               82432     
_________________________________________________________________
dense_1 (Dense)              (None, 11)                1419      
_________________________________________________________________
reshape_5 (Reshape)          (None, 11)                0         
=================================================================
Total params: 108,971
Trainable params: 108,971
Non-trainable params: 0
_________________________________________________________________
各层数据格式
1. cnn1     input       数据格式 16位 1位符号位  0位整数位  15位小数位
                weights   数据格式 16位 1位符号位  1位整数位  14位小数位
	output     数据格式 16位 1位符号位  1位整数位 14位小数位
2. cnn2     input       数据格式 16位 1位符号位   1位整数位 14位小数位
	weights   数据格式 16位 1位符号位   1位整数位 14位小数位  
	output     数据格式 16位 1位符号位  3位整数位 12位小数位
3.lstm       input       数据格式 16位 1位符号位  3位整数位 12位小数位
	weights    数据格式 16位 1位符号位  2位整数位 13位小数位
	bias         数据格式 18位 1位符号位  5位整数位 12位小数位
	output(h) 数据格式 16位 1位符号位  3位整数位 12位小数位

// python 看单层输出
from keras.models import Model
layer_model = Model(inputs=DNN_model.input, outputs=DNN_model.layers[2].output)
feature=layer_model.predict(X_test)
print(np.max(feature))
layer_cnn2 = Model(inputs=DNN_model.input, outputs=DNN_model.layers[5].output)
feature_cnn2=layer_cnn2.predict(X_test)
// 导出权重 
weight_conv1,bias_conv1 = DNN_model.get_layer('conv1').get_weights()
weight_dense,bias_dense = DNN_model.get_layer('dense_1').get_weights()