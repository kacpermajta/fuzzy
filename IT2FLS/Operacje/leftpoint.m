function [l_out,I1u,I1l,wl]= leftpoint(c1,LL,UU);
%% leftpoint.m
%%
%% [l_out,I1u,I1l,wl]= leftpoint(c1,LL,UU);
%%
%% Written by Nilesh N. Karnik - August 9,1998
%% For use with MATLAB 5.1 or higher.
%%
%% Computes c1 the left point of the consequent fuzzy set.
N=length(c1);
[b2,I2]=sort(c1);
L=[];
U=[];
%
for i=1:N
    l=LL(I2(i));
    r=UU(I2(i));
    L=[L,l];
    U=[U,r];
end
%
if sum(L) == 0
    l_out = 0.0;
else
    l_out=b2*L'/sum(L);
end
%
s=b2*L';
s1=sum(L);
%
I1u=[];
I1l=[];
wl=[];
%
for i=1:N
    s=s-b2(i)*L(i)+b2(i)*U(i);
    s1=s1-L(i)+U(i);
    if s/s1<l_out
        l_out=s/s1;
        % wl=[wl,U(i)];
        I1u=[I1u,I2(i)];
    else
        I1l=[I1l,I2(i)];
        % wl=[wl,L(i)];
    end
end
%
L=length(I1u);
for i=1:L
    wl(I1u(i))=UU(I1u(i));
end
%
L=length(I1l);
for i=1:L
    wl(I1l(i))=LL(I1l(i));
end
