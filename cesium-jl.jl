using Random
using Printf
using LinearAlgebra







function rgb(r,g,b)
    "\e[38;2;$(r);$(g);$(b)m"
end

function red()
    rgb(255,0,0)
end

function yellow()
    rgb(255,255,0)
end

function white()
    rgb(255,255,255)
end

function gray(h)
    rgb(h,h,h)
end

function key(n) 
    rand(0:n-1, n, n) 
end

function key(n,b)
    rand(0:b-1, n, n) 
end

function text(b,n) 
    rand(0:b-1, n) 
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

function encode(p,q,b)
    k = copy(q)
    c = Int64[]
    for i in eachindex(p)
        x = tr(k)%b
        push!(c,(p[i] + x)%b )
        isodd((x + p[i])%b) ? spincols(k,p[i]) : spinrows(k,p[i])
    end
    c
end

function decode(p,q,b)
    k = copy(q)
    c = Int64[]
    for i in eachindex(p)
        x = tr(k)%b
        push!(c, (p[i]- x + b )%b)
        isodd((x + c[end])%b) ? spincols(k,c[end]) : spinrows(k,c[end])
    end
    c
end

function encrypt(p, q, b)
    n = size(q)[begin]
    for i in 1:n
        k = spin(q,i)
        p = encode(p,k,b)
        p = reverse(p)
    end
    p
end

function decrypt(p, q, b)
    n = size(q)[begin]
    for i in 1:n
        k = spin(q,n + 1 - i)
        p = reverse(p)
        p = decode(p,k,b)
    end
    p
end

function demo()
    b = 26
    n = 16
    t = 32
    k = key(n,b)
	print(white(),"k =\n",gray(100))
    printkey(k)
    for i in 1:20
    	p = text(b,t)
    	c  = encrypt(p,k,b)
    	d  = decrypt(c,k,b)
    	print(white(),"f( ", red(), str_from_vec(p,""), white()," ) = ")
    	print(yellow(),str_from_vec(c,""), " \n")
    	print(white())
    	if p != d @printf "ERROR" end
    end
end





