;判断bogus vortex
begin

;第一步，确定圆心
f=addfile("./wrfinput_d03","r")
;p=f->P
s_p=wrf_user_getvar(f,"slp",-1)
printVarSummary(s_p)

xlon=f->XLONG
xlat=f->XLAT

ds=dimsizes(s_p)
ntim=ds(0)
nlat=ds(1)
mlon=ds(2)

minp=min(s_p(0,:,:))
m_i=0
m_j=0
    do i=0,nlat-1
        do j=0,mlon-1
           if(s_p(0,i,j).eq.minp) then
                m_i=i
                m_j=j
                end if 
        end do
    end do 
lat_c=xlat(0,m_i,m_j)
lon_c=xlon(0,m_i,m_j)
print(lat_c)
print(lon_c)
print(m_i)
print(m_j)
;asciiwrite("./bogusvortex.txt", (/lat_c,lon_c/))

delete(f)
delete(xlon)
delete(xlat)
delete(ds)
delete(nlat)
delete(mlon)

;第二步，确定半径
f=addfile("./wrfinput_d01","r")

xlon=f->XLONG
xlat=f->XLAT

ds=dimsizes(xlon)

nlat=ds(1)
mlon=ds(2)

time = 0    ; first time step
u_a      = wrf_user_getvar(f, "U",time)          ; grid point height
v_a      = wrf_user_getvar(f, "V",time)          ; grid point height
u_aa     = u_a(:,:,0:mlon-1)
v_aa     = v_a(:,0:nlat-1,:)
  p      = wrf_user_getvar(f, "pressure",time)   ; total pressure
  u  = wrf_user_interp_level(u_aa,p,500,False)
  v  = wrf_user_interp_level(v_aa,p,500,False)
printVarSummary(u)
m_i=0
m_j=0
    do i=0,nlat-1
        do j=0,mlon-1
           if((xlat(0,i,j)-lat_c).lt.0.01.and.(xlon(0,i,j)-lon_c).lt.0.01) then
                m_i=i
                m_j=j
                end if 
        end do
    end do 
    print(m_i)
    print(m_j)
D=min((/m_i,m_j,abs(m_i-nlat),abs(m_j-mlon)/))-5
print(D)
vb=new(D,"float")
do i=1,D
vb(i-1)=(u(m_i+i,m_j)+u(m_i-i,m_j)+v(m_i,m_j+i)+v(m_i,m_j-i))/4.
end do
i=0
do while (vb(i).ge.6.or.abs(vb(i)-vb(i+1)).ge.0.072)
;do while (vb(i).ge.3)
i=i+1
if (i.gt.(D-2)) then
print("i overloaded")
break
end if
end do
R1=i
print(R1)
R=34


;第3步，
delete(f)
delete(xlon)
delete(xlat)
delete(ds)
delete(nlat)
delete(mlon)
delete(s_p)
delete(minp)
f=addfile("./wrfout_d03_2019-08-06_06:00:00","r")
;p=f->P
s_p=wrf_user_getvar(f,"slp",-1)

xlon=f->XLONG
xlat=f->XLAT

ds=dimsizes(s_p)
ntim=ds(0)
nlat=ds(1)
mlon=ds(2)

minp=min(s_p(1,:,:))
m_ii=0
m_jj=0
    do i=0,nlat-1
        do j=0,mlon-1
           if(s_p(1,i,j).eq.minp) then
                m_ii=i
                m_jj=j
                end if 
        end do
    end do 
lat_co=xlat(0,m_ii,m_jj)
lon_co=xlon(0,m_ii,m_jj)
print(lat_co)
print(lon_co)
print(m_ii)
print(m_jj)
asciiwrite("./bogusvortex.txt", (/lat_c,lon_c,lat_co,lon_co,R/))
end