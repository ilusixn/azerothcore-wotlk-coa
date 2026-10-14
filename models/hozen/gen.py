import numpy as np
from PIL import Image, ImageFilter, ImageDraw
import sys,os
S=os.path.join(sys.argv[1] if len(sys.argv)>1 else os.path.join(os.path.dirname(os.path.abspath(__file__)),'retail_source','creature','hozu'),'')
def load(f,sz): return Image.open(S+f).convert('RGBA').resize((sz,sz),Image.LANCZOS)
def noise(n,sz,seed,blur):
    r=np.random.default_rng(seed); im=Image.fromarray((r.random((n,n))*255).astype(np.uint8)).resize((sz,sz),Image.BICUBIC).filter(ImageFilter.GaussianBlur(blur))
    x=np.asarray(im).astype(np.float32)/255; return (x-x.min())/(x.max()-x.min()+1e-6)
def recolor(img,stops,seed,var=0.06):
    a=np.asarray(img).astype(np.float32)/255; L=0.3*a[...,0]+0.59*a[...,1]+0.11*a[...,2]
    sz=L.shape[0]; xs=[s[0] for s in stops]
    rgb=np.stack([np.interp(L,xs,[s[1][c]/255 for s in stops]) for c in range(3)],-1)
    n=(noise(6,sz,seed,sz/20)-0.5)*2*var   # subtle large-scale tone drift
    rgb=rgb*(1+n[...,None])
    return Image.fromarray((np.dstack([rgb,a[...,3]])*255).clip(0,255).astype(np.uint8),'RGBA')
FUR={ # luminance -> colour ramps; bright end = lighter muzzle/belly tones
 'jungle':[(0,(28,18,8)),(.3,(92,62,30)),(.6,(170,125,65)),(1,(235,205,150))],
 'highland':[(0,(22,22,22)),(.3,(70,68,64)),(.6,(130,126,118)),(1,(215,208,195))],
 'mahogany':[(0,(20,8,5)),(.3,(70,28,16)),(.6,(125,58,34)),(1,(200,140,105))],
 'snowy':[(0,(55,50,45)),(.3,(140,134,124)),(.6,(205,200,188)),(1,(248,244,234))],
}
ARM={
 'jungle':[(0,(20,13,8)),(.4,(85,58,35)),(.75,(150,112,72)),(1,(215,185,140))],   # worn leather
 'highland':[(0,(18,16,10)),(.4,(80,62,35)),(.75,(150,120,70)),(1,(205,185,140))], # tarnished bronze
 'mahogany':[(0,(18,8,6)),(.4,(85,30,24)),(.75,(150,70,55)),(1,(210,170,140))],    # faded cloth red
 'snowy':[(0,(12,16,12)),(.4,(52,66,48)),(.75,(105,122,92)),(1,(190,195,170))],    # faded cloth green
}
src=[('fur','hozumonkeywhite.blp',1024,'hozumonkey_'),('armor','hozuarmormailbblue.blp',1024,'hozuarmor_'),('helm','helmhozuarmormailblue.blp',512,'helmhozuarmor_')]
out=[]
for i,vn in enumerate(FUR):
    for part,f,sz,pre in src:
        im=recolor(load(f,sz),FUR[vn] if part=='fur' else ARM[vn],i*10+len(part),0.07 if part=='fur' else 0.04)
        name=pre+vn; im.save(f'png/{name}.png'); im.quantize(256,method=Image.FASTOCTREE).save(f'blp/{name}.blp'); out.append((name,im))
T=280; sheet=Image.new('RGB',(T*3+40,len(FUR)*(T+20)+30),(25,25,30)); d=ImageDraw.Draw(sheet)
for k,(n,im) in enumerate(out):
    r,c=divmod(k,3); bg=Image.new('RGBA',im.size,(60,60,60,255)); bg.alpha_composite(im)
    sheet.paste(bg.convert('RGB').resize((T,T)),(10+c*(T+10),30+r*(T+20))); d.text((10+c*(T+10),15+r*(T+20)),n,fill=(255,255,255))
sheet.save('preview.png')
