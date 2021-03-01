;step0_windloc
begin

f=addfile("./wrfout_d03_2019-08-06_06:00:00","r")
;f=addfile("./wrfinput_d03","w")
p=f->P
pb=f->PB(1,0,:,:)
u10=f->U10(1,:,:) 
v10=f->V10(1,:,:)
u10_ini=f->U10(0,:,:)
v10_ini=f->V10(0,:,:)
u=f->U
s_u=u(1,0,:,:240)
printMinMax(s_u,1)
v=f->V
s_v=v(1,0,:240,:)
s_p=p(1,0,:,:)
printVarSummary(s_p)


xlon=f->XLONG(1,:,:)
xlat=f->XLAT(1,:,:)
 
ds=dimsizes(s_p)

nlat=ds(0)
mlon=ds(1)

 minp=min(s_p(:,:))
 print(minp)
 uv=new((/nlat,mlon/),"float")
 uv10=new((/nlat,mlon/),"float")
 uv10_ini=new((/nlat,mlon/),"float")
 ii=0
 jj=0
 do i=0,nlat-1
        do j=0,mlon-1
   if(s_p(i,j).eq.minp) then
        ii=i
        jj=j
         end if
         uv(i,j)=sqrt(s_u(i,j)^2+s_v(i,j)^2)
         uv10(i,j)=sqrt(u10(i,j)^2+v10(i,j)^2)
         uv10_ini(i,j)=sqrt(u10_ini(i,j)^2+v10_ini(i,j)^2)
 end do
 end do
xp_wrf=xlon(ii,jj)
yp_wrf=xlat(ii,jj)
pb_min=pb(ii,jj)
uv_max=max(uv)
uv10_max=max(uv10)
uv10_ini_max=max(uv10_ini)

diff_uv10=abs(uv10_ini_max-uv10_max)

print(xp_wrf)
print(yp_wrf)
print(uv_max)
print(uv10_max)
print(uv10_ini_max)
print(diff_uv10)
print(pb_min)

end