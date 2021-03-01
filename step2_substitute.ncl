;step2_substitute
begin
z=asciiread("./bogusvortex.txt", -1, "float")

f=addfile("./wrfout_d01_2019-08-06_06:00:00","r")
R=floattointeger(z(4))
lat_c=z(0)
lon_c=z(1)
delta=18
b_t=40
b_t_s=41
pi=3.1415926
print(R)

v_p=f->P 
v_u=f->U 
v_v=f->V 
v_t=f->T  
v_ph=f->PH  
v_vapor=f->QVAPOR 
v_p_t=v_p
printVarSummary(v_vapor)
ds=dimsizes(v_p)
ntim=ds(0)
nlev=ds(1)
nlat=ds(2)
mlon=ds(3)
print(nlat)
;calculate FB 
M=floattoint(((111*cos(lat_c))/delta))
print(M)
hM=floattoint(M/(2.))
q=new(hM+1,"integer")
km=new(hM+1,"integer")
kkm=new(hM+1,"float")
q(0)=M 
do i=1,hM 
q(i)=floattoint(M/(i*2.))
end do 
if (hM.eq.0) then 
km=(/2/)
else if (hM.eq.1) then 
km=(/2,3/)
else if (hM.eq.2) then 
km=(/2,3,4/)
else if (hM.eq.3) then 
km=(/2,3,4,2/)
else if (hM.eq.4) then 
km=(/2,3,4,2,5/)
else if (hM.eq.5) then 
km=(/2,3,4,2,5,6/)
else if (hM.eq.6) then 
km=(/2,3,4,2,5,6,7/)
else if (hM.eq.7) then 
km=(/2,3,4,2,5,6,7,2/)
else if (hM.eq.8) then 
km=(/2,3,4,2,5,6,7,2,8/)
else if (hM.eq.9) then 
km=(/2,3,4,2,5,6,7,2,8,9/)
else if (hM.eq.10) then 
km=(/2,3,4,2,5,6,7,2,8,9,2/)
else 
print("hM is not enough!")
end if 
end if 
end if 
end if 
end if 
end if 
end if 
end if 
end if 
end if 
end if

do i=0,hM
kkm(i)=(0.5*(1-cos((2./km(i))*pi))^(-1))
end do 
print(kkm)

pbar=new((/nlev,nlat-2*M,mlon-2*M/),"float")
pB=new((/nlev,nlat-2*M,mlon-2*M/),"float")
ubar=new((/nlev,nlat-2*M,mlon-2*M/),"float")
uB=new((/nlev,nlat-2*M,mlon-2*M/),"float")
vbar=new((/nlev,nlat-2*M,mlon-2*M/),"float")
vB=new((/nlev,nlat-2*M,mlon-2*M/),"float")
tbar=new((/nlev,nlat-2*M,mlon-2*M/),"float")
tB=new((/nlev,nlat-2*M,mlon-2*M/),"float")
phbar=new((/b_t_s,nlat-2*M,mlon-2*M/),"float")
phB=new((/b_t_s,nlat-2*M,mlon-2*M/),"float")
vaporbar=new((/nlev,nlat-2*M,mlon-2*M/),"float")
vaporB=new((/nlev,nlat-2*M,mlon-2*M/),"float")
    do i=M,nlat-M-1 
        do j=M,mlon-M-1
        pbar(:,i-M,j-M)=v_p(1,:,i,j)+kkm(0)*(v_p(1,:,i-q(0),j)+v_p(1,:,i+q(0),j)-2*v_p(1,:,i,j)) 
        ubar(:,i-M,j-M)=v_u(1,:,i,j)+kkm(0)*(v_u(1,:,i-q(0),j)+v_u(1,:,i+q(0),j)-2*v_u(1,:,i,j))
        vbar(:,i-M,j-M)=v_v(1,:,i,j)+kkm(0)*(v_v(1,:,i-q(0),j)+v_v(1,:,i+q(0),j)-2*v_v(1,:,i,j))
        tbar(:,i-M,j-M)=v_t(1,:,i,j)+kkm(0)*(v_t(1,:,i-q(0),j)+v_t(1,:,i+q(0),j)-2*v_t(1,:,i,j))
        phbar(:,i-M,j-M)=v_ph(1,:,i,j)+kkm(0)*(v_ph(1,:,i-q(0),j)+v_ph(1,:,i+q(0),j)-2*v_ph(1,:,i,j))
        vaporbar(:,i-M,j-M)=v_vapor(1,:,i,j)+kkm(0)*(v_vapor(1,:,i-q(0),j)+v_vapor(1,:,i+q(0),j)-2*v_vapor(1,:,i,j))
            do jj=1,hM
            pbar(:,i-M,j-M)=pbar(:,i-M,j-M)+kkm(jj)*(v_p(1,:,i-q(jj),j)+v_p(1,:,i+q(jj),j)-2*v_p(1,:,i,j))
            ubar(:,i-M,j-M)=ubar(:,i-M,j-M)+kkm(jj)*(v_u(1,:,i-q(jj),j)+v_u(1,:,i+q(jj),j)-2*v_u(1,:,i,j))
            vbar(:,i-M,j-M)=vbar(:,i-M,j-M)+kkm(jj)*(v_v(1,:,i-q(jj),j)+v_v(1,:,i+q(jj),j)-2*v_v(1,:,i,j))
            tbar(:,i-M,j-M)=tbar(:,i-M,j-M)+kkm(jj)*(v_t(1,:,i-q(jj),j)+v_t(1,:,i+q(jj),j)-2*v_t(1,:,i,j))
            phbar(:,i-M,j-M)=phbar(:,i-M,j-M)+kkm(jj)*(v_ph(1,:,i-q(jj),j)+v_ph(1,:,i+q(jj),j)-2*v_ph(1,:,i,j))
            vaporbar(:,i-M,j-M)=vaporbar(:,i-M,j-M)+kkm(jj)*(v_vapor(1,:,i-q(jj),j)+v_vapor(1,:,i+q(jj),j)-2*v_vapor(1,:,i,j)) 
            end do 
        pB(:,i-M,j-M)=pbar(:,i-M,j-M)+kkm(0)*(v_p(1,:,i,j-q(0))+v_p(1,:,i,j+q(0))-2*v_p(1,:,i,j))
        uB(:,i-M,j-M)=ubar(:,i-M,j-M)+kkm(0)*(v_u(1,:,i,j-q(0))+v_u(1,:,i,j+q(0))-2*v_u(1,:,i,j))
        vB(:,i-M,j-M)=vbar(:,i-M,j-M)+kkm(0)*(v_v(1,:,i,j-q(0))+v_v(1,:,i,j+q(0))-2*v_v(1,:,i,j))
        tB(:,i-M,j-M)=tbar(:,i-M,j-M)+kkm(0)*(v_t(1,:,i,j-q(0))+v_t(1,:,i,j+q(0))-2*v_t(1,:,i,j))
        phB(:,i-M,j-M)=phbar(:,i-M,j-M)+kkm(0)*(v_ph(1,:,i,j-q(0))+v_ph(1,:,i,j+q(0))-2*v_ph(1,:,i,j))
        vaporB(:,i-M,j-M)=vaporbar(:,i-M,j-M)+kkm(0)*(v_vapor(1,:,i,j-q(0))+v_vapor(1,:,i,j+q(0))-2*v_vapor(1,:,i,j)) 
            do jj=1,hM
            pB(:,i-M,j-M)=pB(:,i-M,j-M)+kkm(jj)*(v_p(1,:,i,j-q(jj))+v_p(1,:,i,j+q(jj))-2*v_p(1,:,i,j))
            uB(:,i-M,j-M)=uB(:,i-M,j-M)+kkm(jj)*(v_u(1,:,i,j-q(jj))+v_u(1,:,i,j+q(jj))-2*v_u(1,:,i,j))
            vB(:,i-M,j-M)=vB(:,i-M,j-M)+kkm(jj)*(v_v(1,:,i,j-q(jj))+v_v(1,:,i,j+q(jj))-2*v_v(1,:,i,j))
            tB(:,i-M,j-M)=tB(:,i-M,j-M)+kkm(jj)*(v_t(1,:,i,j-q(jj))+v_t(1,:,i,j+q(jj))-2*v_t(1,:,i,j))
            phB(:,i-M,j-M)=phB(:,i-M,j-M)+kkm(jj)*(v_ph(1,:,i,j-q(jj))+v_ph(1,:,i,j+q(jj))-2*v_ph(1,:,i,j))
            vaporB(:,i-M,j-M)=vaporB(:,i-M,j-M)+kkm(jj)*(v_vapor(1,:,i,j-q(jj))+v_vapor(1,:,i,j+q(jj))-2*v_vapor(1,:,i,j)) 
            end do 
        end do 
    end do 


pD=new((/nlev,nlat-2*M,mlon-2*M/),"float")
uD=new((/nlev,nlat-2*M,mlon-2*M/),"float")
vD=new((/nlev,nlat-2*M,mlon-2*M/),"float")
tD=new((/nlev,nlat-2*M,mlon-2*M/),"float")
phD=new((/b_t_s,nlat-2*M,mlon-2*M/),"float")
vaporD=new((/nlev,nlat-2*M,mlon-2*M/),"float")
    do i=M,nlat-M-1 
        do j=M,mlon-M-1
        pD(:,i-M,j-M)=v_p(1,:,i,j)-pB(:,i-M,j-M)
        uD(:,i-M,j-M)=v_u(1,:,i,j)-uB(:,i-M,j-M)
        vD(:,i-M,j-M)=v_v(1,:,i,j)-vB(:,i-M,j-M)
        tD(:,i-M,j-M)=v_t(1,:,i,j)-tB(:,i-M,j-M)
        phD(:,i-M,j-M)=v_ph(1,:,i,j)-phB(:,i-M,j-M)
        vaporD(:,i-M,j-M)=v_vapor(1,:,i,j)-vaporB(:,i-M,j-M) 
        end do 
    end do 


;=========================================================
;以上计算出了FD，全部算是准备过程，接下来的操作是对半径R内的操作
;=========================================================

;定位输出中的坐标
xlon=f->XLONG
xlat=f->XLAT

m_i=0
m_j=0
    do i=M,nlat-M-1 
        do j=M,mlon-M-1
           if((xlat(1,i,j)-z(2)).lt.0.01.and.(xlon(1,i,j)-z(3)).lt.0.01) then
                m_i=i
                m_j=j
                end if 
        end do
    end do 
    print(m_i)
    print(m_j)

;计算常量ER和FDbar
;p=new((R+1),"float") 
E=new((R+1),"float")  
do i=0,R
    E(i)=(exp((-(R-i)^2)/((0.2*R)^2))-exp((-(R)^2)/((0.2*R)^2)))/(1-exp((-(R)^2)/((0.2*R)^2)))       
end do 

pDS=new(nlev,"float")
pDbar=new(nlev,"float")
do i=0,nlev-1
pDS(i)=0.
end do

do i=-R,R 
pDS(:)=pDS(:)+pD(:,m_i+R,m_j+i)
end do
do i=-R,R 
pDS(:)=pDS(:)+pD(:,m_i-R,m_j+i)
end do
do i=-R,R 
pDS(:)=pDS(:)+pD(:,m_i+i,m_j+R)
end do
do i=-R,R 
pDS(:)=pDS(:)+pD(:,m_i+i,m_j-R)
end do 
pDbar(:)=pDS(:)/(8.*R)

uDS=new(nlev,"float")
uDbar=new(nlev,"float")
do i=0,nlev-1
uDS(i)=0.
end do

do i=-R,R 
uDS(:)=uDS(:)+uD(:,m_i+R,m_j+i)
end do
do i=-R,R 
uDS(:)=uDS(:)+uD(:,m_i-R,m_j+i)
end do
do i=-R,R 
uDS(:)=uDS(:)+uD(:,m_i+i,m_j+R)
end do
do i=-R,R 
uDS(:)=uDS(:)+uD(:,m_i+i,m_j-R)
end do 
uDbar(:)=uDS(:)/(8.*R)

vDS=new(nlev,"float")
vDbar=new(nlev,"float")
do i=0,nlev-1
vDS(i)=0.
end do

do i=-R,R 
vDS(:)=vDS(:)+vD(:,m_i+R,m_j+i)
end do
do i=-R,R 
vDS(:)=vDS(:)+vD(:,m_i-R,m_j+i)
end do
do i=-R,R 
vDS(:)=vDS(:)+vD(:,m_i+i,m_j+R)
end do
do i=-R,R 
vDS(:)=vDS(:)+vD(:,m_i+i,m_j-R)
end do 
vDbar(:)=vDS(:)/(8.*R)

tDS=new(nlev,"float")
tDbar=new(nlev,"float")
do i=0,nlev-1
tDS(i)=0.
end do

do i=-R,R 
tDS(:)=tDS(:)+tD(:,m_i+R,m_j+i)
end do
do i=-R,R 
tDS(:)=tDS(:)+tD(:,m_i-R,m_j+i)
end do
do i=-R,R 
tDS(:)=tDS(:)+tD(:,m_i+i,m_j+R)
end do
do i=-R,R 
tDS(:)=tDS(:)+tD(:,m_i+i,m_j-R)
end do 
tDbar(:)=tDS(:)/(8.*R)

phDS=new(b_t_s,"float")
phDbar=new(b_t_s,"float")
do i=0,b_t_s-1
phDS(i)=0.
end do

do i=-R,R 
phDS(:)=phDS(:)+phD(:,m_i+R,m_j+i)
end do
do i=-R,R 
phDS(:)=phDS(:)+phD(:,m_i-R,m_j+i)
end do
do i=-R,R 
phDS(:)=phDS(:)+phD(:,m_i+i,m_j+R)
end do
do i=-R,R 
phDS(:)=phDS(:)+phD(:,m_i+i,m_j-R)
end do 
phDbar(:)=phDS(:)/(8.*R)

vaporDS=new(nlev,"float")
vaporDbar=new(nlev,"float")
do i=0,nlev-1
vaporDS(i)=0.
end do

do i=-R,R 
vaporDS(:)=vaporDS(:)+vaporD(:,m_i+R,m_j+i)
end do
do i=-R,R 
vaporDS(:)=vaporDS(:)+vaporD(:,m_i-R,m_j+i)
end do
do i=-R,R 
vaporDS(:)=vaporDS(:)+vaporD(:,m_i+i,m_j+R)
end do
do i=-R,R 
vaporDS(:)=vaporDS(:)+vaporD(:,m_i+i,m_j-R)
end do 
vaporDbar(:)=vaporDS(:)/(8.*R)


;计算FV
pV=pD 
uV=uD
vV=vD
tV=tD
phV=phD 
vaporV=vaporD 

    do i=-R,R
        do j=-R,R 
        r=max((/abs(i),abs(j)/))   
      pV(:,m_i+i,m_j+j)=pD(:,m_i+i,m_j+j)-(pD(:,m_i+i,m_j+j)*E(r)+pDbar(:)*(1-E(r)))
      uV(:,m_i+i,m_j+j)=uD(:,m_i+i,m_j+j)-(uD(:,m_i+i,m_j+j)*E(r)+uDbar(:)*(1-E(r)))
      vV(:,m_i+i,m_j+j)=vD(:,m_i+i,m_j+j)-(vD(:,m_i+i,m_j+j)*E(r)+vDbar(:)*(1-E(r)))
      phV(:,m_i+i,m_j+j)=phD(:,m_i+i,m_j+j)-(phD(:,m_i+i,m_j+j)*E(r)+phDbar(:)*(1-E(r)))
      vaporV(:,m_i+i,m_j+j)=vaporD(:,m_i+i,m_j+j)-(vaporD(:,m_i+i,m_j+j)*E(r)+vaporDbar(:)*(1-E(r)))
        end do       
    end do 

;计算FVax

pVS=new((/nlev,R+1/),"float")
pVax=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
pVS(i,k)=0.
pVax(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
pVS(:,k)=pVS(:,k)+pV(:,m_i+k,m_j+i)
end do
do i=-k,k 
pVS(:,k)=pVS(:,k)+pV(:,m_i-k,m_j+i)
end do
do i=-k,k 
pVS(:,k)=pVS(:,k)+pV(:,m_i+i,m_j+k)
end do
do i=-k,k 
pVS(:,k)=pVS(:,k)+pV(:,m_i+i,m_j-k)
end do  
pVax(:,k)=pVS(:,k)/(8.*k)
end do 

uVS=new((/nlev,R+1/),"float")
uVax=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
uVS(i,k)=0.
uVax(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
uVS(:,k)=uVS(:,k)+uV(:,m_i+k,m_j+i)
end do
do i=-k,k 
uVS(:,k)=uVS(:,k)+uV(:,m_i-k,m_j+i)
end do
do i=-k,k 
uVS(:,k)=uVS(:,k)+uV(:,m_i+i,m_j+k)
end do
do i=-k,k 
uVS(:,k)=uVS(:,k)+uV(:,m_i+i,m_j-k)
end do  
uVax(:,k)=uVS(:,k)/(8.*k)
end do 

vVS=new((/nlev,R+1/),"float")
vVax=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
vVS(i,k)=0.
vVax(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
vVS(:,k)=vVS(:,k)+vV(:,m_i+k,m_j+i)
end do
do i=-k,k 
vVS(:,k)=vVS(:,k)+vV(:,m_i-k,m_j+i)
end do
do i=-k,k 
vVS(:,k)=vVS(:,k)+vV(:,m_i+i,m_j+k)
end do
do i=-k,k 
vVS(:,k)=vVS(:,k)+vV(:,m_i+i,m_j-k)
end do  
vVax(:,k)=vVS(:,k)/(8.*k)
end do 

tVS=new((/nlev,R+1/),"float")
tVax=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
tVS(i,k)=0.
tVax(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
tVS(:,k)=tVS(:,k)+tV(:,m_i+k,m_j+i)
end do
do i=-k,k 
tVS(:,k)=tVS(:,k)+tV(:,m_i-k,m_j+i)
end do
do i=-k,k 
tVS(:,k)=tVS(:,k)+tV(:,m_i+i,m_j+k)
end do
do i=-k,k 
tVS(:,k)=tVS(:,k)+tV(:,m_i+i,m_j-k)
end do  
tVax(:,k)=tVS(:,k)/(8.*k)
end do 

phVS=new((/b_t_s,R+1/),"float")
phVax=new((/b_t_s,R+1/),"float")
do i=0,b_t_s-1
do k=0,R 
phVS(i,k)=0.
phVax(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
phVS(:,k)=phVS(:,k)+phV(:,m_i+k,m_j+i)
end do
do i=-k,k 
phVS(:,k)=phVS(:,k)+phV(:,m_i-k,m_j+i)
end do
do i=-k,k 
phVS(:,k)=phVS(:,k)+phV(:,m_i+i,m_j+k)
end do
do i=-k,k 
phVS(:,k)=phVS(:,k)+phV(:,m_i+i,m_j-k)
end do  
phVax(:,k)=phVS(:,k)/(8.*k)
end do 

vaporVS=new((/nlev,R+1/),"float")
vaporVax=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
vaporVS(i,k)=0.
vaporVax(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
vaporVS(:,k)=vaporVS(:,k)+vaporV(:,m_i+k,m_j+i)
end do
do i=-k,k 
vaporVS(:,k)=vaporVS(:,k)+vaporV(:,m_i-k,m_j+i)
end do
do i=-k,k 
vaporVS(:,k)=vaporVS(:,k)+vaporV(:,m_i+i,m_j+k)
end do
do i=-k,k 
vaporVS(:,k)=vaporVS(:,k)+vaporV(:,m_i+i,m_j-k)
end do  
vaporVax(:,k)=vaporVS(:,k)/(8.*k)
end do 

;;;
;;;
;;;
;=============================================================
;接下来是替换过程，这个时候会在wrfinput文件里重复上述过程，然后替换
;=============================================================
;;;
;;;
;;;

delete(f)
delete(v_p)
delete(v_u)
delete(v_v)
delete(v_t)
delete(v_ph)
delete(v_vapor)
delete(ds)
delete(m_i)
delete(m_j)

f=addfile("./wrfinput_d01","w")

v_p=f->P 
v_u=f->U 
v_v=f->V 
v_t=f->T  
v_ph=f->PH  
v_vapor=f->QVAPOR


ds=dimsizes(v_p)
ntim=ds(0)
nlev=ds(1)
nlat=ds(2)
mlon=ds(3)

    do i=M,nlat-M-1 
        do j=M,mlon-M-1
        pbar(:,i-M,j-M)=v_p(0,:,i,j)+kkm(0)*(v_p(0,:,i-q(0),j)+v_p(0,:,i+q(0),j)-2*v_p(0,:,i,j)) 
        ubar(:,i-M,j-M)=v_u(0,:,i,j)+kkm(0)*(v_u(0,:,i-q(0),j)+v_u(0,:,i+q(0),j)-2*v_u(0,:,i,j))
        vbar(:,i-M,j-M)=v_v(0,:,i,j)+kkm(0)*(v_v(0,:,i-q(0),j)+v_v(0,:,i+q(0),j)-2*v_v(0,:,i,j))
        tbar(:,i-M,j-M)=v_t(0,:,i,j)+kkm(0)*(v_t(0,:,i-q(0),j)+v_t(0,:,i+q(0),j)-2*v_t(0,:,i,j))
        phbar(:,i-M,j-M)=v_ph(0,:,i,j)+kkm(0)*(v_ph(0,:,i-q(0),j)+v_ph(0,:,i+q(0),j)-2*v_ph(0,:,i,j))
        vaporbar(:,i-M,j-M)=v_vapor(0,:,i,j)+kkm(0)*(v_vapor(0,:,i-q(0),j)+v_vapor(0,:,i+q(0),j)-2*v_vapor(0,:,i,j))
            do jj=1,hM
            pbar(:,i-M,j-M)=pbar(:,i-M,j-M)+kkm(jj)*(v_p(0,:,i-q(jj),j)+v_p(0,:,i+q(jj),j)-2*v_p(0,:,i,j))
            ubar(:,i-M,j-M)=ubar(:,i-M,j-M)+kkm(jj)*(v_u(0,:,i-q(jj),j)+v_u(0,:,i+q(jj),j)-2*v_u(0,:,i,j))
            vbar(:,i-M,j-M)=vbar(:,i-M,j-M)+kkm(jj)*(v_v(0,:,i-q(jj),j)+v_v(0,:,i+q(jj),j)-2*v_v(0,:,i,j))
            tbar(:,i-M,j-M)=tbar(:,i-M,j-M)+kkm(jj)*(v_t(0,:,i-q(jj),j)+v_t(0,:,i+q(jj),j)-2*v_t(0,:,i,j))
            phbar(:,i-M,j-M)=phbar(:,i-M,j-M)+kkm(jj)*(v_ph(0,:,i-q(jj),j)+v_ph(0,:,i+q(jj),j)-2*v_ph(0,:,i,j))
            vaporbar(:,i-M,j-M)=vaporbar(:,i-M,j-M)+kkm(jj)*(v_vapor(0,:,i-q(jj),j)+v_vapor(0,:,i+q(jj),j)-2*v_vapor(0,:,i,j)) 
            end do 
        pB(:,i-M,j-M)=pbar(:,i-M,j-M)+kkm(0)*(v_p(0,:,i,j-q(0))+v_p(0,:,i,j+q(0))-2*v_p(0,:,i,j))
        uB(:,i-M,j-M)=ubar(:,i-M,j-M)+kkm(0)*(v_u(0,:,i,j-q(0))+v_u(0,:,i,j+q(0))-2*v_u(0,:,i,j))
        vB(:,i-M,j-M)=vbar(:,i-M,j-M)+kkm(0)*(v_v(0,:,i,j-q(0))+v_v(0,:,i,j+q(0))-2*v_v(0,:,i,j))
        tB(:,i-M,j-M)=tbar(:,i-M,j-M)+kkm(0)*(v_t(0,:,i,j-q(0))+v_t(0,:,i,j+q(0))-2*v_t(0,:,i,j))
        phB(:,i-M,j-M)=phbar(:,i-M,j-M)+kkm(0)*(v_ph(0,:,i,j-q(0))+v_ph(0,:,i,j+q(0))-2*v_ph(0,:,i,j))
        vaporB(:,i-M,j-M)=vaporbar(:,i-M,j-M)+kkm(0)*(v_vapor(0,:,i,j-q(0))+v_vapor(0,:,i,j+q(0))-2*v_vapor(0,:,i,j)) 
            do jj=1,hM
            pB(:,i-M,j-M)=pB(:,i-M,j-M)+kkm(jj)*(v_p(0,:,i,j-q(jj))+v_p(0,:,i,j+q(jj))-2*v_p(0,:,i,j))
            uB(:,i-M,j-M)=uB(:,i-M,j-M)+kkm(jj)*(v_u(0,:,i,j-q(jj))+v_u(0,:,i,j+q(jj))-2*v_u(0,:,i,j))
            vB(:,i-M,j-M)=vB(:,i-M,j-M)+kkm(jj)*(v_v(0,:,i,j-q(jj))+v_v(0,:,i,j+q(jj))-2*v_v(0,:,i,j))
            tB(:,i-M,j-M)=tB(:,i-M,j-M)+kkm(jj)*(v_t(0,:,i,j-q(jj))+v_t(0,:,i,j+q(jj))-2*v_t(0,:,i,j))
            phB(:,i-M,j-M)=phB(:,i-M,j-M)+kkm(jj)*(v_ph(0,:,i,j-q(jj))+v_ph(0,:,i,j+q(jj))-2*v_ph(0,:,i,j))
            vaporB(:,i-M,j-M)=vaporB(:,i-M,j-M)+kkm(jj)*(v_vapor(0,:,i,j-q(jj))+v_vapor(0,:,i,j+q(jj))-2*v_vapor(0,:,i,j)) 
            end do 
        end do 
    end do 



    do i=M,nlat-M-1 
        do j=M,mlon-M-1
        pD(:,i-M,j-M)=v_p(0,:,i,j)-pB(:,i-M,j-M)
        uD(:,i-M,j-M)=v_u(0,:,i,j)-uB(:,i-M,j-M)
        vD(:,i-M,j-M)=v_v(0,:,i,j)-vB(:,i-M,j-M)
        tD(:,i-M,j-M)=v_t(0,:,i,j)-tB(:,i-M,j-M)
        phD(:,i-M,j-M)=v_ph(0,:,i,j)-phB(:,i-M,j-M)
        vaporD(:,i-M,j-M)=v_vapor(0,:,i,j)-vaporB(:,i-M,j-M) 
        end do 
    end do 


;=========================================================
;以上计算出了FD，全部算是准备过程，接下来的操作是对半径R内的操作
;=========================================================

;定位输出中的坐标
m_i=0
m_j=0
    do i=M,nlat-M-1 
        do j=M,mlon-M-1
           if((xlat(0,i,j)-z(0)).lt.0.01.and.(xlon(0,i,j)-z(1)).lt.0.01) then
                m_i=i
                m_j=j
                end if 
        end do
    end do 
    print(m_i)
    print(m_j)



do i=0,nlev-1
pDS(i)=0.
end do

do i=-R,R 
pDS(:)=pDS(:)+pD(:,m_i+R,m_j+i)
end do
do i=-R,R 
pDS(:)=pDS(:)+pD(:,m_i-R,m_j+i)
end do
do i=-R,R 
pDS(:)=pDS(:)+pD(:,m_i+i,m_j+R)
end do
do i=-R,R 
pDS(:)=pDS(:)+pD(:,m_i+i,m_j-R)
end do 
pDbar(:)=pDS(:)/(8.*R)


do i=0,nlev-1
uDS(i)=0.
end do

do i=-R,R 
uDS(:)=uDS(:)+uD(:,m_i+R,m_j+i)
end do
do i=-R,R 
uDS(:)=uDS(:)+uD(:,m_i-R,m_j+i)
end do
do i=-R,R 
uDS(:)=uDS(:)+uD(:,m_i+i,m_j+R)
end do
do i=-R,R 
uDS(:)=uDS(:)+uD(:,m_i+i,m_j-R)
end do 
uDbar(:)=uDS(:)/(8.*R)


do i=0,nlev-1
vDS(i)=0.
end do

do i=-R,R 
vDS(:)=vDS(:)+vD(:,m_i+R,m_j+i)
end do
do i=-R,R 
vDS(:)=vDS(:)+vD(:,m_i-R,m_j+i)
end do
do i=-R,R 
vDS(:)=vDS(:)+vD(:,m_i+i,m_j+R)
end do
do i=-R,R 
vDS(:)=vDS(:)+vD(:,m_i+i,m_j-R)
end do 
vDbar(:)=vDS(:)/(8.*R)


do i=0,nlev-1
tDS(i)=0.
end do

do i=-R,R 
tDS(:)=tDS(:)+tD(:,m_i+R,m_j+i)
end do
do i=-R,R 
tDS(:)=tDS(:)+tD(:,m_i-R,m_j+i)
end do
do i=-R,R 
tDS(:)=tDS(:)+tD(:,m_i+i,m_j+R)
end do
do i=-R,R 
tDS(:)=tDS(:)+tD(:,m_i+i,m_j-R)
end do 
tDbar(:)=tDS(:)/(8.*R)

do i=0,b_t_s-1
phDS(i)=0.
end do

do i=-R,R 
phDS(:)=phDS(:)+phD(:,m_i+R,m_j+i)
end do
do i=-R,R 
phDS(:)=phDS(:)+phD(:,m_i-R,m_j+i)
end do
do i=-R,R 
phDS(:)=phDS(:)+phD(:,m_i+i,m_j+R)
end do
do i=-R,R 
phDS(:)=phDS(:)+phD(:,m_i+i,m_j-R)
end do 
phDbar(:)=phDS(:)/(8.*R)


do i=0,nlev-1
vaporDS(i)=0.
end do

do i=-R,R 
vaporDS(:)=vaporDS(:)+vaporD(:,m_i+R,m_j+i)
end do
do i=-R,R 
vaporDS(:)=vaporDS(:)+vaporD(:,m_i-R,m_j+i)
end do
do i=-R,R 
vaporDS(:)=vaporDS(:)+vaporD(:,m_i+i,m_j+R)
end do
do i=-R,R 
vaporDS(:)=vaporDS(:)+vaporD(:,m_i+i,m_j-R)
end do 
vaporDbar(:)=vaporDS(:)/(8.*R)


;计算FV
pV=pD 
uV=uD
vV=vD
tV=tD
phV=phD 
vaporV=vaporD 

    do i=-R,R
        do j=-R,R 
        r=max((/abs(i),abs(j)/))   
      pV(:,m_i+i,m_j+j)=pD(:,m_i+i,m_j+j)-(pD(:,m_i+i,m_j+j)*E(r)+pDbar(:)*(1-E(r)))
      uV(:,m_i+i,m_j+j)=uD(:,m_i+i,m_j+j)-(uD(:,m_i+i,m_j+j)*E(r)+uDbar(:)*(1-E(r)))
      vV(:,m_i+i,m_j+j)=vD(:,m_i+i,m_j+j)-(vD(:,m_i+i,m_j+j)*E(r)+vDbar(:)*(1-E(r)))
      phV(:,m_i+i,m_j+j)=phD(:,m_i+i,m_j+j)-(phD(:,m_i+i,m_j+j)*E(r)+phDbar(:)*(1-E(r)))
      vaporV(:,m_i+i,m_j+j)=vaporD(:,m_i+i,m_j+j)-(vaporD(:,m_i+i,m_j+j)*E(r)+vaporDbar(:)*(1-E(r)))
        end do       
    end do 

;计算FVax

pVS_in=new((/nlev,R+1/),"float")
pVax_in=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
pVS_in(i,k)=0.
pVax_in(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
pVS_in(:,k)=pVS_in(:,k)+pV(:,m_i+k,m_j+i)
end do
do i=-k,k 
pVS_in(:,k)=pVS_in(:,k)+pV(:,m_i-k,m_j+i)
end do
do i=-k,k 
pVS_in(:,k)=pVS_in(:,k)+pV(:,m_i+i,m_j+k)
end do
do i=-k,k 
pVS_in(:,k)=pVS_in(:,k)+pV(:,m_i+i,m_j-k)
end do  
pVax_in(:,k)=pVS_in(:,k)/(8.*k)
end do 

uVS_in=new((/nlev,R+1/),"float")
uVax_in=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
uVS_in(i,k)=0.
uVax_in(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
uVS_in(:,k)=uVS_in(:,k)+uV(:,m_i+k,m_j+i)
end do
do i=-k,k 
uVS_in(:,k)=uVS_in(:,k)+uV(:,m_i-k,m_j+i)
end do
do i=-k,k 
uVS_in(:,k)=uVS_in(:,k)+uV(:,m_i+i,m_j+k)
end do
do i=-k,k 
uVS_in(:,k)=uVS_in(:,k)+uV(:,m_i+i,m_j-k)
end do  
uVax_in(:,k)=uVS_in(:,k)/(8.*k)
end do 


vVS_in=new((/nlev,R+1/),"float")
vVax_in=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
vVS_in(i,k)=0.
vVax_in(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
vVS_in(:,k)=vVS_in(:,k)+vV(:,m_i+k,m_j+i)
end do
do i=-k,k 
vVS_in(:,k)=vVS_in(:,k)+vV(:,m_i-k,m_j+i)
end do
do i=-k,k 
vVS_in(:,k)=vVS_in(:,k)+vV(:,m_i+i,m_j+k)
end do
do i=-k,k 
vVS_in(:,k)=vVS_in(:,k)+vV(:,m_i+i,m_j-k)
end do  
vVax_in(:,k)=vVS_in(:,k)/(8.*k)
end do 

tVS_in=new((/nlev,R+1/),"float")
tVax_in=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
tVS_in(i,k)=0.
tVax_in(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
tVS_in(:,k)=tVS_in(:,k)+tV(:,m_i+k,m_j+i)
end do
do i=-k,k 
tVS_in(:,k)=tVS_in(:,k)+tV(:,m_i-k,m_j+i)
end do
do i=-k,k 
tVS_in(:,k)=tVS_in(:,k)+tV(:,m_i+i,m_j+k)
end do
do i=-k,k 
tVS_in(:,k)=tVS_in(:,k)+tV(:,m_i+i,m_j-k)
end do  
tVax_in(:,k)=tVS_in(:,k)/(8.*k)
end do 

phVS_in=new((/b_t_s,R+1/),"float")
phVax_in=new((/b_t_s,R+1/),"float")
do i=0,b_t_s-1
do k=0,R 
phVS_in(i,k)=0.
phVax_in(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
phVS_in(:,k)=phVS_in(:,k)+phV(:,m_i+k,m_j+i)
end do
do i=-k,k 
phVS_in(:,k)=phVS_in(:,k)+phV(:,m_i-k,m_j+i)
end do
do i=-k,k 
phVS_in(:,k)=phVS_in(:,k)+phV(:,m_i+i,m_j+k)
end do
do i=-k,k 
phVS_in(:,k)=phVS_in(:,k)+phV(:,m_i+i,m_j-k)
end do  
phVax_in(:,k)=phVS_in(:,k)/(8.*k)
end do 

vaporVS_in=new((/nlev,R+1/),"float")
vaporVax_in=new((/nlev,R+1/),"float")
do i=0,nlev-1
do k=0,R 
vaporVS_in(i,k)=0.
vaporVax_in(i,k)=0.
end do 
end do 

do k=1,R 
do i=-k,k 
vaporVS_in(:,k)=vaporVS_in(:,k)+vaporV(:,m_i+k,m_j+i)
end do
do i=-k,k 
vaporVS_in(:,k)=vaporVS_in(:,k)+vaporV(:,m_i-k,m_j+i)
end do
do i=-k,k 
vaporVS_in(:,k)=vaporVS_in(:,k)+vaporV(:,m_i+i,m_j+k)
end do
do i=-k,k 
vaporVS_in(:,k)=vaporVS_in(:,k)+vaporV(:,m_i+i,m_j-k)
end do  
vaporVax_in(:,k)=vaporVS_in(:,k)/(8.*k)
end do 

;substitute

v_p_n=v_p
v_u_n=v_u  
v_v_n=v_v  
v_t_n=v_t  
v_ph_n=v_ph 
v_vapor_n=v_vapor




do i=-R,R
    do j=-R,R 
        r=max((/abs(i),abs(j)/)) 
        if (r.gt.(R/2.)) then 
        wr=exp(-((2*(r-R))/(0.4*R))^2)
        else 
        wr=0
        end if  
      v_p_n(0,:,m_i+i,m_j+j)=v_p(0,:,m_i+i,m_j+j)-pVax_in(:,r)+wr*pVax_in(:,r)+(1-wr)*pVax(:,r)
      v_u_n(0,:,m_i+i,m_j+j)=v_u(0,:,m_i+i,m_j+j)-uVax_in(:,r)+wr*uVax_in(:,r)+(1-wr)*uVax(:,r)
      v_v_n(0,:,m_i+i,m_j+j)=v_v(0,:,m_i+i,m_j+j)-vVax_in(:,r)+wr*vVax_in(:,r)+(1-wr)*vVax(:,r)
      v_t_n(0,:,m_i+i,m_j+j)=v_t(0,:,m_i+i,m_j+j)-tVax_in(:,r)+wr*tVax_in(:,r)+(1-wr)*tVax(:,r)
      v_ph_n(0,:,m_i+i,m_j+j)=v_ph(0,:,m_i+i,m_j+j)-phVax_in(:,r)+wr*phVax_in(:,r)+(1-wr)*phVax(:,r)
      v_vapor_n(0,:,m_i+i,m_j+j)=v_vapor(0,:,m_i+i,m_j+j)-vaporVax_in(:,r)+wr*vaporVax_in(:,r)+(1-wr)*vaporVax(:,r)
    end do       
end do 
printVarSummary(v_ph_n)
printVarSummary(v_ph)
f->P=v_p_n   
f->U=v_u_n   
f->V=v_v_n   
f->T=v_t_n  
f->PH=v_ph_n  
f->QVAPOR=v_vapor_n

delete(f)
delete(v_p)
delete(v_u)
delete(v_v)
delete(v_t)
delete(v_ph)
delete(v_vapor)
delete(ds)
delete(m_i)
delete(m_j)

    
end