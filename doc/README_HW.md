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

![HW](./images/hw%20design.png)

