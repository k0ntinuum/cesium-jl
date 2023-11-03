using Random
using Printf
using LinearAlgebra




str_from_vec(v)  = join(map(i -> alph[i+1:i+1], v))

function printkey(k)
	for i in 1:n print(join(map(i -> alph[i+1:i+1]*" ", k[i,:])),"\n") end
	print("\n")
end

str_from_vec(v,c)  = join(map(i -> alph[i+1:i+1]*c, v))

vec_from_str(s) = map(i -> findfirst(isequal(i),alph),collect(s))

rgb(r,g,b) =  "\e[38;2;$(r);$(g);$(b)m"

red() = rgb(255,0,0);yellow() = rgb(255,255,0);white() = rgb(255,255,255);gray(h) = rgb(h,h,h)
blue() = rgb(0,0,255);

function key(n) rand(0:n-1, n, n) end
function key(n,b) rand(0:b-1, n, n) end
function text(n)  rand(0:b-1, n) end

function spinrows(k)
    for j in 1:size(k)[begin]
            k[j,:] = circshift(k[j,:],k[j,j])
    end
end

function spincols(k)
    for j in 1:size(k)[begin]
        k[:,j] = circshift(k[:,j],k[j,j])
    end 
end

function spinrows(k,p)
    for j in 1:size(k)[begin]
            k[j,:] = circshift(k[j,:],k[j,j]+p+1)
    end
end

function spincols(k,p)
    for j in 1:size(k)[begin]
        k[:,j] = circshift(k[:,j],k[j,j]+p+1)
    end 
end

function spin(q,n)
    k = copy(q)
    for i in 1:n
        isodd(tr(k)+ i) ? spincols(k) : spinrows(k)
    end
    k
end

function encode(p,q)
    k = copy(q)
    c = zeros(Int64,length(p))
    for i in eachindex(p)
        x = tr(k)%b
        c[i] = (p[i] + x)%b
        # isodd((x + p[i])%b) ? spincols(k) : spinrows(k)
        isodd((x + p[i])%b) ? spincols(k,p[i]) : spinrows(k,p[i])
    end
    c
end

function decode(p,q)
    k = copy(q)
    c = zeros(Int64,length(p))
    for i in eachindex(p)
        x = tr(k)%b
        c[i] = (p[i]- x + b )%b
        # isodd((x + c[i])%b) ? spincols(k) : spinrows(k)
        isodd((x + c[i])%b) ? spincols(k,c[i]) : spinrows(k,c[i])
    end
    c
end

function encrypt(p, q, r)
    for i in 1:r
        k = spin(q,i)
        p = encode(p,k)
        p = reverse(p)
    end
    p
end

function decrypt(p, q, r)
    for i in 1:r
        k = spin(q,r + 1 - i)
        p = reverse(p)
        p = decode(p,k)
    end
    p
end



function demo()
	print(white(),"k =\n",gray(100))
    printkey(k)
    for i in 1:20
    	p = text(t)
    	c  = encrypt(p,k,r)
    	d  = decrypt(c,k,r)
    	print(white(),"f( ", red(), str_from_vec(p), white()," ) = ")
    	print(yellow(),str_from_vec(c), " \n")
    	print(white())
    	if p != d @printf "ERROR" end
    end
end

#global

#alph = "abcdefghijklmnopqrstuvwxyz"
#alph = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#alph = "O123456789"
alph = "O|"
#n  = 16 * length(alph)
n = 16
t = 32
#t = length(alph)
k = key(n)
b = length(alph)
r = 20

k = key(n,b)

