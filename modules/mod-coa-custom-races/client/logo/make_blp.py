import sys,os;sys.path[:0]=[r'C:\CoA-Build\esteria_racials',r'C:\CoA-Build\logo']
import estlib,blp
from PIL import Image
C=estlib.Client(estlib.OUR_DATA)
src=Image.open(r'C:\Users\ilusi\AppData\Local\Temp\claude\C--Program-Files--x86--Steam-steamapps-common-Assassin-s-Creed-Black-Flag-Resynced\d6f2176a-cfae-45f1-878b-a98d1307c3f6\images\445.webp').convert('RGBA')
src=src.crop(src.getchannel('A').point(lambda v:255 if v>8 else 0).getbbox())
print('logo',src.size)
jobs=[(r'Interface\GLUES\COMMON\Glues-WoW-WotLKLogo_AS.blp',1.06),(r'Interface\GLUES\MainMenu\AscensionLogo.blp',1.05)]
for n,k in jobs:
    d,_=C.read(n);old,info=blp.decode(d)
    x0,y0,x1,y1=old.getchannel('A').getbbox()
    th=int((y1-y0)*k);tw=int(src.size[0]*th/src.size[1]);tw=min(tw,old.size[0]-4)
    th=int(tw*src.size[1]/src.size[0])
    new=Image.new('RGBA',old.size,(0,0,0,0))
    l=src.resize((tw,th),Image.LANCZOS)
    new.alpha_composite(l,((x0+x1)//2-tw//2,(y0+y1)//2-th//2))
    out=blp.encode(new,info)
    p=os.path.join(r'C:\CoA-Build\logo\patch',*n.split(chr(92)))
    os.makedirs(os.path.dirname(p),exist_ok=True);open(p,'wb').write(out)
    chk,_=blp.decode(out);assert chk.size==old.size
    print(n,tw,th,len(out))
