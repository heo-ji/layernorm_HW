#### 데이터 버스 512-bit 버스 기반

**512bit = [ row 31  | row 30 | … | row 1  | row 0 ]**
= 16bit(8.8)*32개 row  
  
bits[15:0]    = row0[k]   (row0의 k번째 샘플)  
bits[31:16]   = row1[k]  
...  
bits[511:496] = row31[k]  (row31의 k번째 샘플)  


![Overview](./images/overview.png)

![timing diagram](./images/timing_diagram_cal_one_row.png)
![timing diagram2](./images/timing_diagram_cal_one_row_rev2.png)
![timing diagram3](./images/timing_diagram_normalization.png)


![functional description](./images/functional%20description.png)

* 입력 값 설정*  
bert_base의 경우  
i_d_model = 768  
i_shift_value = 5'sd8  
i_mult_value = 8'sb01010101  
--------------------------------------------  
Dividing by model_dimension (to get the mean value) => Shift and Multiply(0.8 Q-format) operations 으로 구현  
  
x / i_d_model = x >>> i_shift_value * i_mult_value  
x / 768 = x >>>8 * 0.33203125 (8'sb01010101)  
x / 192 = x >>>6 * 0.33203125  
x / 384 = x >>>7 * * 0.33203125  
x / 1024 = x >>>12 * 0.25 (8'sb01000000)  
x / 1280 = x >>>8 * 0.19921875 (8'sb 00110011)  
  

![HW](./images/hw%20design.png)

