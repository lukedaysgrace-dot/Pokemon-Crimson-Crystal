"""Standalone SVG charts (ReportLab) and high-resolution PNG companions.

ReportLab is used as the vector plotting backend. Pillow rasterizes the same
explicit plot geometry for previews without requiring optional Cairo bindings.
"""
import json
import math
from pathlib import Path
from reportlab.graphics import renderSVG
from reportlab.graphics.shapes import Drawing,Line,PolyLine,Rect,String,Circle
from reportlab.lib.colors import HexColor
from PIL import Image,ImageDraw,ImageFont
from extract import HERE

PALETTE=['#1765a7','#13836a','#dc7e18','#944c9c','#9b2938','#6e7781']

def chart(filename,title,subtitle,labels,series,ylabel,ymax=None,bar=False):
    W,H=1500,720;L,R,T,B=110,120,120,195;pw=W-L-R;ph=H-T-B
    values=[v for _,vals,_ in series for v in vals]
    ymax=ymax or max(1,max(values))*1.12
    tick=10**math.floor(math.log10(ymax/5))
    step=next(x*tick for x in [1,2,5,10] if x*tick>=ymax/6)
    ymax=math.ceil(ymax/step)*step
    d=Drawing(W,H);im=Image.new('RGB',(W,H),'white');dr=ImageDraw.Draw(im)
    fonts={n:ImageFont.truetype('C:/Windows/Fonts/segoeui.ttf',n) for n in [14,16,18,20,24,32]}
    def line(x1,y1,x2,y2,color='#dce2e8',width=1,dash=None):
        shape=Line(x1,H-y1,x2,H-y2,strokeColor=HexColor(color),strokeWidth=width)
        if dash:shape.strokeDashArray=dash
        d.add(shape)
        if not dash:dr.line((x1,y1,x2,y2),fill=color,width=max(1,round(width)))
        else:
            length=math.hypot(x2-x1,y2-y1)
            for a in range(0,int(length),12):
                b=min(length,a+6)
                dr.line((x1+(x2-x1)*a/length,y1+(y2-y1)*a/length,x1+(x2-x1)*b/length,y1+(y2-y1)*b/length),fill=color,width=max(1,round(width)))
    def text(x,y,s,size=18,color='#273444',anchor='start'):
        d.add(String(x,H-y-size*.85,s,fontName='Helvetica',fontSize=size,fillColor=HexColor(color),textAnchor=anchor))
        box=dr.textbbox((0,0),s,font=fonts[size]);width=box[2]-box[0]
        offset=0 if anchor=='start' else width/2 if anchor=='middle' else width
        dr.text((x-offset,y-2),s,font=fonts[size],fill=color)
    def rect(x,y,w,h,color):
        d.add(Rect(x,H-y-h,w,h,fillColor=HexColor(color),strokeColor=None))
        dr.rectangle((x,y,x+w,y+h),fill=color)
    text(L,18,title,32)
    text(L,61,subtitle,18,'#566475')
    text(L,92,ylabel,16,'#566475')
    for j in range(int(ymax/step)+1):
        val=j*step;y=T+ph*(1-val/ymax)
        line(L,y,W-R,y)
        text(L-15,y-9,f'{val:,.0f}',16,'#566475','end')
    line(L,T,L,T+ph,'#7b8794');line(L,T+ph,W-R,T+ph,'#7b8794')
    n=len(labels);dx=pw/max(1,n-1 if not bar else n)
    for i,label in enumerate(labels):
        x=L+dx*(i+.5 if bar else i)
        line(x,T+ph,x,T+ph+7,'#7b8794')
        # Rotate labels in both exports so complete milestone names remain legible.
        sx=x+3;sy=T+ph+16
        from reportlab.graphics.shapes import Group
        g=Group(String(0,0,label,fontName='Helvetica',fontSize=14,fillColor=HexColor('#425466')))
        g.translate(sx,H-sy);g.rotate(-55);d.add(g)
        temp=Image.new('RGBA',(330,38),(255,255,255,0));td=ImageDraw.Draw(temp)
        td.text((2,2),label,font=fonts[14],fill='#425466')
        temp=temp.rotate(-55,expand=True)
        im.paste(temp,(round(sx-25),round(sy-8)),temp)
    for si,(name,vals,color) in enumerate(series):
        if bar:
            bw=dx*.76/len(series)
            for i,value in enumerate(vals):
                x=L+dx*i+dx*.12+si*bw;h=ph*value/ymax
                rect(x,T+ph-h,bw*.92,h,color)
        else:
            pts=[]
            for i,value in enumerate(vals):pts.extend([L+dx*i,H-(T+ph*(1-value/ymax))])
            d.add(PolyLine(pts,strokeColor=HexColor(color),strokeWidth=3,fillColor=None))
            for i in range(len(vals)-1):line(L+dx*i,T+ph*(1-vals[i]/ymax),L+dx*(i+1),T+ph*(1-vals[i+1]/ymax),color,3)
            for i,value in enumerate(vals):
                x=L+dx*i;y=T+ph*(1-value/ymax)
                d.add(Circle(x,H-y,3,fillColor=HexColor(color),strokeColor=None));dr.ellipse((x-3,y-3,x+3,y+3),fill=color)
        lx=L+(si%4)*290;ly=H-35-(math.ceil(len(series)/4)-1)*27+(si//4)*27
        rect(lx,ly,22,8,color);text(lx+31,ly-9,name,16)
    renderSVG.drawToFile(d,str(HERE/(filename+'.svg')))
    im.save(HERE/(filename+'.png'))

def main():
    b=json.loads((HERE/'baseline_results.json').read_text())
    get=lambda n,m='equal_rotation',s='typical':b[f'{s}:{n}:{m}']
    rows=get(6);gyms=rows[:16];end=rows[16:]
    chart('01_gym_progression','Gym progression: four versus six planned team members','Pre-boss levels; gradual recruitment; seed 0; 2 travel KOs per new eligible map',[r['milestone'] for r in gyms],[('Actual Hard cap',[r['hard_cap'] for r in gyms],PALETTE[4]),('4, balanced rotation',[r['average_level'] for r in get(4)[:16]],PALETTE[0]),('6, balanced rotation',[r['average_level'] for r in gyms],PALETTE[1]),('6, lead gets 45%',[r['average_level'] for r in get(6,'casual')[:16]],PALETTE[2])],'Average party level',70)
    chart('02_endgame_progression','Unique battles do not support the endgame level ramp','Actual Hard cap is 100 after badge 16; the red line below is the boss ace, not a cap',[r['milestone'] for r in end],[('Boss ace',[r['boss_ace'] for r in end],PALETTE[4]),('4, balanced rotation',[r['average_level'] for r in get(4)[16:]],PALETTE[0]),('6, balanced rotation',[r['average_level'] for r in end],PALETTE[1]),('6, lead gets 45%',[r['average_level'] for r in get(6,'casual')[16:]],PALETTE[2])],'Level',100)
    chart('03_trainer_exp_supply','Trainer EXP offered between gym milestones','Solo-equivalent Hard EXP; post-previous-boss to pre-next-boss; not party EXP earned',[r['milestone'] for r in gyms],[(label,[r['segment_solo_available']/1000 for r in get(6,s=style)[:16]],color) for style,label,color in [('minimal','Minimal-route scenario',PALETTE[5]),('typical','Typical-route scenario',PALETTE[0]),('completionist','Scheduled completionist',PALETTE[1])]],'Trainer EXP (thousands)',bar=True)
    chart('04_exp_deficits','EXP still required to bring every member to the target','Target = actual cap during gyms, boss ace afterwards; each checkpoint is independently unground',[r['milestone'] for r in rows],[('4, balanced rotation',[r['target_shortfall']/1000 for r in get(4)],PALETTE[0]),('6, balanced rotation',[r['target_shortfall']/1000 for r in rows],PALETTE[1]),('6, lead gets 45%',[r['target_shortfall']/1000 for r in get(6,'casual')],PALETTE[2])],'Remaining EXP (thousands)')
    chart('05_cap_waste','EXP lost at progression caps','Clipped awards plus pools with no uncapped recipient; capped participants are removed from the divisor',[r['milestone'] for r in gyms],[(label,[r['segment_wasted']/1000 for r in get(n,method)[:16]],color) for n,method,label,color in [(4,'equal_rotation','4, balanced rotation',PALETTE[0]),(6,'equal_rotation','6, balanced rotation',PALETTE[1]),(6,'casual','6, lead gets 45%',PALETTE[2])]],'Cap loss (thousands)',bar=True)
    chart('06_level_gap_spikes','Progression pressure: boss ace minus median party level','A level-gap proxy only; held items, abilities, stats and matchups are reviewed separately',[r['milestone'] for r in rows],[(label,[max(0,r['boss_ace']-sorted(r['levels'])[len(r['levels'])//2]) for r in get(n,method)],color) for n,method,label,color in [(4,'equal_rotation','4, balanced rotation',PALETTE[0]),(6,'equal_rotation','6, balanced rotation',PALETTE[1]),(6,'casual','6, lead gets 45%',PALETTE[2])]],'Boss level advantage')
    chart('07_exp_surpluses','EXP already above the current boss target','Progression caps prevent gym overshoot; post-badge-16 target is the boss ace, not cap 100',[r['milestone'] for r in rows],[(f'{n} members, balanced',[r['target_surplus']/1000 for r in get(n)],PALETTE[i]) for i,n in enumerate([1,2,4,6])],'Surplus EXP (thousands)',bar=True)
    chart('08_all_team_sizes','All six team sizes: balanced rotation','Recruitment is staggered; same selected trainer itinerary; no repeated training added',[r['milestone'] for r in rows],[(f'{n} planned members',[r['average_level'] for r in get(n)],PALETTE[n-1]) for n in range(1,7)],'Average party level',100)
    print('Created eight SVG charts and eight PNG previews.')

if __name__=='__main__':main()
