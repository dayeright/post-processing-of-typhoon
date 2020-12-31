begin
;-----第一部分：读取最佳路径集里的台风附近最大风速-----
data=asciiread("./besttrack.txt",-1,"string")
st_best_t=stringtofloat(str_get_cols(data,32,35))
st_best=st_best_t/1.
printMinMax(st_best,1)

;-----第二部分：读取模式输出风场资料-------------
f=addfile("./wrfout_d01_2019-08-05_00:00:00","r")
u=f->U
s_u=u(:,0,:,:35)
printMinMax(s_u,1)
v=f->V
s_v=v(:,0,:41,:)
printMinMax(s_v,1)
printVarSummary(s_v)
printVarSummary(s_u)

;--------第三部分：计算台风路径附近最大风速-----
ds=dimsizes(s_u)
ntim=ds(0)
nlat=ds(1)
mlon=ds(2)

uv=new((/ntim,nlat,mlon/),"float")
uv_max=new(ntim,"float")
time=new(ntim,"float")
do k=0,ntim-1
	do i=0,nlat-1
	 do j=0,mlon-1
		uv(k,i,j)=sqrt(s_u(k,i,j)^2+s_v(k,i,j)^2)
         end do
	end do
uv_max(k)=max(uv(k,:,:))
time(k)=k+1
end do

;-------第四部分：台风强度比较折线图-----
wks=gsn_open_wks("png","lqm_stregth")

res	= True
res@gsnDraw            = False             ; don't draw yet
res@gsnFrame           = False             ; don't advance frame yet
res@tiMainString	=	"LQM intensity"
res@xyLineThicknesses = (/  1.0,   2.0/)          ; make second line thicker
res@xyLineColors      = (/"black","red"/)          ; change line color
res@xyDashPatterns	=(/0.,0./)
res@tmXBMode          ="Explicit"
res@tmXBValues        = (/time(0),time(4),time(8),time(12),time(16)/)
res@tmXBLabels = (/"08-05_00","08-06_00","08-07_00","08-08_00","08-09_00"/) 
plot  = gsn_csm_xy (wks,time,(/st_best,uv_max/),res) ; create plot

   lgres                    = True
   lgres@lgLineColors       = (/"black","red"/)
   lgres@lgLineThicknessF   = (/1.0,2.0/) 
   lgres@lgLabelFontHeightF = .05            ; set the legend label font thickness
   lgres@vpWidthF           = 0.15           ; width of legend (NDC)
   lgres@vpHeightF          = 0.05            ; height of legend (NDC)
   lgres@lgMonoDashIndex    = True   
   lgres@lgPerimColor       = "orange"       ; draw the box perimeter in orange
  ;lgres@lgPerimThicknessF = 3.0            ; thicken the box perimeter
   labels = (/"V_OBS","V_WRF"/)

; Create the legend.
   lbid   = gsn_create_legend(wks,2,labels,lgres)         ; create legend
   amres = True
   amres@amParallelPosF   =  0.27 	         ; positive move legend to the right
   amres@amOrthogonalPosF = -0.42                 ; positive move the legend down
   annoid1 = gsn_add_annotation(plot,lbid,amres)   ; attach legend to plot
   draw(plot)                                           
   frame(wks) 

end
