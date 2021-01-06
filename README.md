# typhoon-post-processing
This repository contains the files about post-processing of typhoon.

台风最佳路径集获取地址：
http://tcdata.typhoon.org.cn/zjljsjj_sm.html

The simulation to LEKIMA by WRF（concluded in directionary of LEKIMA）:
使用了vortex-following, 使用了nudging，模拟时间2019-08-05_00:00:00~2019-08-09_00:00:00，前六小时spin-up舍去.
因为vortex-following输出文件中包括了，通过平均海表气压最小值和10-m风速最大值确定的台风中心和强度，因此这里直接用此信息来做后处理,输出文件保存在：
grep ATCF rsl.out.* >& wrftrack.txt

nudging run 参考：https://www2.mmm.ucar.edu/wrf/users/wrfv3.1/How_to_run_grid_fdda.html

vortex-following run 参考本项目文件: Moving-Nested Run.txt（搬运自 WRFUsersGuide)
