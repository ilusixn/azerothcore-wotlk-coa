import struct, numpy as np
from PIL import Image
def read(d):
    magic,typ,enc,ad,ae,mips,w,h=struct.unpack_from('<4sIBBBBII',d,0)
    offs=struct.unpack_from('<16I',d,20);sizes=struct.unpack_from('<16I',d,84)
    return dict(enc=enc,ad=ad,ae=ae,mips=mips,w=w,h=h,off=offs,size=sizes)
def decode(d):
    i=read(d)
    if i['enc']==3:
        a=np.frombuffer(d[i['off'][0]:i['off'][0]+i['w']*i['h']*4],np.uint8).reshape(i['h'],i['w'],4)
        return Image.fromarray(a[...,[2,1,0,3]],'RGBA'),i
    raise Exception('enc %d'%i['enc'])
def encode(im,like):
    im=im.convert('RGBA');w,h=im.size
    levels=[];cur=im
    while True:
        levels.append(cur)
        if cur.size[0]==1 and cur.size[1]==1: break
        cur=cur.resize((max(1,cur.size[0]//2),max(1,cur.size[1]//2)),Image.LANCZOS)
    hdr=bytearray(148)
    struct.pack_into('<4sIBBBBII',hdr,0,b'BLP2',1,3,8,like['ae'],1,w,h)
    pos=148;offs=[0]*16;sizes=[0]*16;body=b''
    for k,l in enumerate(levels[:16]):
        a=np.asarray(l)[...,[2,1,0,3]].tobytes()
        offs[k]=pos+len(body);sizes[k]=len(a);body+=a
    struct.pack_into('<16I',hdr,20,*offs);struct.pack_into('<16I',hdr,84,*sizes)
    return bytes(hdr)+body
