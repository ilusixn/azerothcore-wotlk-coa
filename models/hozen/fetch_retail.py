#!/usr/bin/env python3
"""Download the retail Hozen (creature/hozu/hozumonkey, DisplayID 41083) files from wago.tools by FileDataID.
Files land in ./retail_source/ (git-ignored; Blizzard assets are NOT stored in this repo).
Usage: python3 fetch_retail.py [--textures-only]"""
import os, sys, urllib.request
HERE = os.path.dirname(os.path.abspath(__file__))
FILES = {
    536927: "creature/hozu/hozumonkey.m2",
    536928: "creature/hozu/hozumonkey0062-00.anim",
    536929: "creature/hozu/hozumonkey0062-01.anim",
    536930: "creature/hozu/hozumonkey00.skin",
    536931: "creature/hozu/hozumonkey01.skin",
    536941: "creature/hozu/hozumonkeyblue.blp",
    536942: "creature/hozu/hozumonkeybrown.blp",
    536943: "creature/hozu/hozumonkeygreen.blp",
    536944: "creature/hozu/hozumonkeyorange.blp",
    536945: "creature/hozu/hozumonkeyred.blp",
    536946: "creature/hozu/hozumonkeywhite.blp",
    588646: "creature/hozu/hozumonkeybody.blp",
    588647: "creature/hozu/hozumonkey0084-00.anim",
    588648: "creature/hozu/hozumonkey02.skin",
    588870: "creature/hozu/hozumonkey0097-00.anim",
    588949: "creature/hozu/hozumonkey0096-00.anim",
    589019: "creature/hozu/hozumonkey0098-00.anim",
    589256: "creature/hozu/hozumonkey0070-00.anim",
    589257: "creature/hozu/hozumonkey0060-00.anim",
    589533: "creature/hozu/hozumonkey0067-00.anim",
    589858: "creature/hozu/hozumonkey03.skin",
    589891: "creature/hozu/hozumonkey0065-00.anim",
    589892: "creature/hozu/hozumonkey0129-00.anim",
    589893: "creature/hozu/hozumonkey0123-00.anim",
    589894: "creature/hozu/hozumonkey0128-00.anim",
    591649: "creature/hozu/hozumonkey0068-00.anim",
    591979: "creature/hozu/hozumonkey0061-00.anim",
    627304: "creature/hozu/hozumonkey0100-00.anim",
    627305: "creature/hozu/hozumonkey0099-00.anim",
    627306: "creature/hozu/hozumonkey0101-00.anim",
    633145: "creature/hozu/hozumonkey0732-00.anim",
    2200509: "creature/hozu/hozumonkey_lod01.skin",
    589822: "creature/hozu/helmhozuarmorclothblue.blp",
    589823: "creature/hozu/helmhozuarmorclothdark.blp",
    589824: "creature/hozu/helmhozuarmorclothgreen.blp",
    589825: "creature/hozu/helmhozuarmorclothpale.blp",
    589826: "creature/hozu/helmhozuarmormailblue.blp",
    589827: "creature/hozu/helmhozuarmormailgreen.blp",
    589828: "creature/hozu/helmhozuarmormailorange.blp",
    589829: "creature/hozu/helmhozuarmormailred.blp",
    589830: "creature/hozu/helmhozuarmormailteal.blp",
    589831: "creature/hozu/hozuarmorclothablue.blp",
    589832: "creature/hozu/hozuarmorclothadark.blp",
    589833: "creature/hozu/hozuarmorclothagreen.blp",
    589834: "creature/hozu/hozuarmorclothapale.blp",
    589835: "creature/hozu/hozuarmorclothbblue.blp",
    589836: "creature/hozu/hozuarmorclothbdark.blp",
    589837: "creature/hozu/hozuarmorclothbgreen.blp",
    589838: "creature/hozu/hozuarmorclothbpale.blp",
    589839: "creature/hozu/hozuarmorclothcblue.blp",
    589840: "creature/hozu/hozuarmorclothcdark.blp",
    589841: "creature/hozu/hozuarmorclothcgreen.blp",
    589842: "creature/hozu/hozuarmorclothcpale.blp",
    589843: "creature/hozu/hozuarmormailablue.blp",
    589844: "creature/hozu/hozuarmormailagreen.blp",
    589845: "creature/hozu/hozuarmormailaorange.blp",
    589846: "creature/hozu/hozuarmormailared.blp",
    589847: "creature/hozu/hozuarmormailateal.blp",
    589848: "creature/hozu/hozuarmormailbblue.blp",
    589849: "creature/hozu/hozuarmormailbgreen.blp",
    589850: "creature/hozu/hozuarmormailborange.blp",
    589851: "creature/hozu/hozuarmormailbred.blp",
    589852: "creature/hozu/hozuarmormailbteal.blp",
    589853: "creature/hozu/hozuarmormailcblue.blp",
    589854: "creature/hozu/hozuarmormailcgreen.blp",
    589855: "creature/hozu/hozuarmormailcorange.blp",
    589857: "creature/hozu/hozuarmormailcred.blp",
    590191: "creature/hozu/hozuarmormailcteal.blp",
}
def main():
    only_tex = "--textures-only" in sys.argv
    for fid, path in FILES.items():
        if only_tex and not path.endswith(".blp"): continue
        dst = os.path.join(HERE, "retail_source", *path.split("/"))
        if os.path.exists(dst) and os.path.getsize(dst) > 0: continue
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        req = urllib.request.Request(f"https://wago.tools/api/casc/{fid}", headers={"User-Agent": "hozen-fetch/1.0"})
        with urllib.request.urlopen(req, timeout=120) as r, open(dst + ".part", "wb") as f: f.write(r.read())
        os.replace(dst + ".part", dst); print("ok", fid, path)
if __name__ == "__main__": main()
