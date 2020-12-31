begin

;-----第一部分：读取最佳路径------------
;-----存储变量为xp_best，yp_best-------
data=asciiread("./besttrack.txt",-1,"string")
xp_best_t=stringtofloat(str_get_cols(data,17,21))
yp_best_t=stringtofloat(str_get_cols(data,13,16))
yp_best=yp_best_t/10.
xp_best=xp_best_t/10.

;------第二部分：读取模式中slp场--------
;-----这里有其他程序用slp=wrf_user_getvar(f,"slp",-1)，这个函数本质上即为取气压场最底层数据
f=addfile("./wrfout_d01_2019-08-05_00:00:00","r")
p=f->P
s_p=p(:,0,:,:)
printMinMax(xp_best,1)
printMinMax(yp_best,1)

;------第三部分：追踪台风------------
;------这里介绍的是，通过找台风路径附近slp场最小值来追踪台风
;------需要注意：这个方法选择的区域必须十分精确的在某台风路径周围，否则很可能定位到其他低气压区域
xlon=f->XLONG
xlat=f->XLAT

ds=dimsizes(s_p)
ntim=ds(0)
nlat=ds(1)
mlon=ds(2)

xp_wrf_t=new(ntim,"float")
yp_wrf_t=new(ntim,"float")

do k=0,ntim-1
minp=min(s_p(k,:,:))
ii=0
jj=0
 do i=0,nlat-1
	do j=0,mlon-1
   if(s_p(k,i,j).eq.minp) then
	ii=i
	jj=j
	end if
end do
end do
xp_wrf_t(k)=xlon(k,ii,jj)
yp_wrf_t(k)=xlat(k,ii,jj)
end do

xp_wrf=new(17,"float")
yp_wrf=new(17,"float")
yp_wrf=yp_wrf_t
xp_wrf=xp_wrf_t

;-------------------------------------------
;这一部分注释掉的程序为从一小时间隔的输出中，每六小时确定一次位置的程序（用于多网格嵌套）
;xp_wrf(0)=xp_wrf_t(0)
;yp_wrf(0)=yp_wrf_t(0)
;xp_wrf(1:)=xp_wrf_t(6::6)
;yp_wrf(1:)=yp_wrf_t(6::6)
;-------------------------------------------

printMinMax(yp_wrf,1)
printMinMax(xp_wrf,1)


;-------第四部分：台风路径画图部分--------
   wks      = gsn_open_wks("png","lqm_track1")       

   res             = True
   res@gsnDraw     = False                         ; don't draw
   res@gsnFrame    = False                         ; don't advance frame
   res@gsnMaximize = True

   res@mpFillOn              = False
   res@mpPerimOn             = True
   res@mpOutlineBoundarySets = "GeophysicalAndUSStates"
   res@pmTickMarkDisplayMode = "Always"

   res@mpLimitMode = "LatLon"        ; select subregion
   res@mpMinLatF   = 14 
   res@mpMaxLatF   = 30                
   res@mpMinLonF   = 115
   res@mpMaxLonF   = 135

   res@tmYROn      = False     ; turn off right and top tickmarks
   res@tmXTOn      = False

   res@tiMainString      = "Hurricane LQM track"  ; title
   res@tiMainFontHeightF = 0.02

   map = gsn_csm_map(wks,res)                     ; create map

; Set up some legend resources.
   lgres                    = True
   lgres@lgLineColors       = (/"black","red"/)
   lgres@lgLineThicknessF   = 2. 
   lgres@lgLabelFontHeightF = .08            ; set the legend label font thickness
   lgres@vpWidthF           = 0.15           ; width of legend (NDC)
   lgres@vpHeightF          = 0.1            ; height of legend (NDC)
   lgres@lgMonoDashIndex    = True   
   lgres@lgPerimColor       = "orange"       ; draw the box perimeter in orange
  ;lgres@lgPerimThicknessF = 3.0            ; thicken the box perimeter
   labels = (/"Best track","WRF track"/)

; Create the legend.
   lbid   = gsn_create_legend(wks,2,labels,lgres)         ; create legend

; Set up resources to attach legend to map.
   amres = True
   amres@amParallelPosF   =  0.27 	         ; positive move legend to the right
   amres@amOrthogonalPosF = -0.35                 ; positive move the legend down
   annoid1 = gsn_add_annotation(map,lbid,amres)   ; attach legend to plot
 
; Add text of every 6 hours  
   txres               = True
   txres@txFontHeightF = 0.015        
   txres@txFontColor   = "black"
   text1 = gsn_add_text(wks,map,"06",xp_best(0)+0.1,yp_best(0)+0.1,txres)
   text2 = gsn_add_text(wks,map,"12",xp_best(1)+0.15,yp_best(1),txres)

; Add trajectory lines.
   pres                  = True               ; polyline resources
   pres@gsLineThicknessF = 3.0                ; line thickness
   pres@gsLineColor      = "black"
   line1 = gsn_add_polyline(wks,map,xp_best,yp_best,pres)      ; draw the traj

   pres                  = True               ; polyline resources
   pres@gsLineColor      = "red"
   line2 = gsn_add_polyline(wks,map,xp_wrf,yp_wrf,pres)      ; draw the traj



; Add markers to the trajectories.
   mres                = True         ; marker resources for best track
   mres@gsMarkerIndex  = 16           ; marker style (filled circle)
   mres@gsMarkerSizeF  = 8.0          ; marker size
   mres@gsMarkerColor  = "black"      ; maker color
   markers = gsn_add_polymarker(wks,map,xp_best,yp_best,mres)

   draw(map)                                           
   frame(wks) 
end 
