import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
import install

root = install.find_repack()
bots = install.choose_bots()
races = install.choose_bot_races() if bots != 'off' else 'vanilla'
install.set_bots(root, bots, races)
install.say(r'Restart the server (CoA-Bots\Start_All_Bots.bat) for the new settings to apply.')
