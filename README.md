**修士過程の研究で開発したソースコード**

# 音響シミュレーションプログラム

**最適化した信号による音圧分布のシミュレーション**
```
matlab/optimization.m
```

**音響放射力の大きさ, 向きをシミュレーション**
```
matlab/orce_quiver_phased.m
```

# 出力信号の最適化

### 最小二乗法により逆フィルタを導出

**目標音場を形成**
```
matlab/make_control_point2.m
```

** 最小二乗法により最適化 **

```
matlab/test_LS2.m
```
### 非線形最適化による最適化
```
matlab/optimization_w.m
```
## python

**マルチチャンネル再生**

物体を非接触で操作
```
python/manipulate.py
```


リアルタイムに信号を切り替え→滑らかな非接触制御を実現
