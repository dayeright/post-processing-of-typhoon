begin
f=addfile("./wrfout_d02_2019-08-05_00:00:00","r")
data=asciiread("./besttrack.txt",-1,"string")
xp_best_t=stringtofloat(str_get_cols(data,17,21))
yp_best_t=stringtofloat(str_get_cols(data,13,16))
yp_best=yp_best_t/10.
xp_best=xp_best_t/10.

printMinMax(xp_best,1)
printMinMax(yp_best,1)

p=f->P
xlon=f->XLONG
xlat=f->XLAT
s_p=p(:,0,:,:)
ds=dimsizes(s_p)
ntim=ds(0)
nlat=ds(1)
mlon=ds(2)


xp_wrf_t=new(ntim,"float")
yp_wrf_t=new(ntim,"float")

do k=0,ntim-1
minp=min(s_p(k,:,:))
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

xp_wrf=xp_wrf_t(::6)
yp_wrf=yp_wrf_t(::6)
printMinMax(yp_wrf,1)
printMinMax(xp_wrf,1)



   wks      = gsn_open_wks("png","lqm_track")       ; send graphics to PNG file

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
