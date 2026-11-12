#define GB_INTERNAL
#include "gb.h"
#include <stdlib.h>
#include <string.h>
typedef struct {GB_gameboy_t *gb; int16_t *pcm; unsigned count; uint32_t pixels[160*144];} Capture;
static uint32_t rgb(GB_gameboy_t *gb, uint8_t r, uint8_t g, uint8_t b) {
    return r | (g << 8) | (b << 16) | 0xff000000;
}
static void sample(GB_gameboy_t *gb, GB_sample_t *s) {
    Capture *c=GB_get_user_data(gb);
    if(c->count<48000*20){c->pcm[c->count*2]=s->left;c->pcm[c->count*2+1]=s->right;c->count++;}
}
Capture *cry_new(const char *rom) {
    Capture *c=calloc(1,sizeof(*c));c->pcm=malloc(48000*20*4);
    c->gb=GB_init(GB_alloc(),GB_MODEL_CGB_E);
    GB_set_user_data(c->gb,c);GB_set_rendering_disabled(c->gb,true);
    GB_set_turbo_mode(c->gb,true,true);GB_set_sample_rate(c->gb,48000);
    GB_set_highpass_filter_mode(c->gb, GB_HIGHPASS_ACCURATE);
    GB_apu_set_sample_callback(c->gb,sample);
    if(GB_load_rom(c->gb,rom))return NULL;
    unsigned char boot[0x900]={0};
    unsigned char start[]={0xf3,0x31,0xfe,0xff,0x01,0,0,0x11,0x56,0xff,0x21,0x0d,0,
        0x3e,0x91,0xe0,0x40,0x3e,0x11,0xc3,0xfc,0};
    memcpy(boot,start,sizeof(start));boot[0xfc]=0x3e;boot[0xfd]=0x11;boot[0xfe]=0xe0;boot[0xff]=0x50;
    GB_load_boot_rom_from_buffer(c->gb,boot,sizeof(boot));
    for(int i=0;i<500;i++)GB_run_frame(c->gb);
    c->count=0;return c;
}
int cry_invoke(Capture *c,unsigned bank,unsigned address,unsigned hbank,unsigned de) {
    GB_gameboy_t *g=c->gb;
    GB_write_memory(g,0xff70,1);
    if(bank){GB_write_memory(g,0x2000,bank);GB_write_memory(g,hbank,bank);}
    unsigned char code[]={0xfb,0xc3,address&255,address>>8};
    for(int i=0;i<4;i++)GB_write_memory(g,0xc0f6+i,code[i]);
    GB_write_memory(g,0xc0ec,0xf0);GB_write_memory(g,0xc0ed,0xc0);
    GB_write_memory(g,0xc0f0,0xfb);GB_write_memory(g,0xc0f1,0x18);GB_write_memory(g,0xc0f2,0xfe);
    GB_registers_t *r=GB_get_registers(g);r->sp=0xc0ec;r->pc=0xc0f6;r->de=de;
    g->halted=false;g->stopped=false;g->ime=true;
    c->count=0;
    for(unsigned i=0;i<20000000;i++){GB_run(g);if(r->pc==0xc0f1||r->pc==0xc0f3)return c->count;}
    return -r->pc;
}
void *cry_pcm(Capture*c){return c->pcm;}
unsigned cry_read(Capture*c,unsigned a){return GB_read_memory(c->gb,a);}
void cry_write(Capture*c,unsigned a,unsigned v){GB_write_memory(c->gb,a,v);}
void cry_free(Capture*c){GB_dealloc(c->gb);free(c->pcm);free(c);}
void cry_video(Capture*c){
    GB_set_rgb_encode_callback(c->gb,rgb);
    GB_set_pixels_output(c->gb,c->pixels);
    GB_set_rendering_disabled(c->gb,false);
}
int cry_frame(Capture*c,unsigned keys){
    GB_set_key_mask(c->gb,keys);c->count=0;GB_run_frame(c->gb);return c->count;
}
void *cry_pixels(Capture*c){return c->pixels;}
size_t cry_state_size(Capture*c){return GB_get_save_state_size(c->gb);}
void cry_save(Capture*c,void*p){GB_save_state_to_buffer(c->gb,p);}
int cry_load(Capture*c,const void*p,size_t size){return GB_load_state_from_buffer(c->gb,p,size);}
/* Private fixture setup, before recording. Running footage uses key masks only. */
unsigned cry_register(Capture*c,unsigned index,unsigned value,unsigned write){
    GB_registers_t *r=GB_get_registers(c->gb);
    uint16_t *reg;
    switch(index){
        case 0:reg=&r->pc;break; case 1:reg=&r->sp;break;
        case 2:reg=&r->af;break; case 3:reg=&r->bc;break;
        case 4:reg=&r->de;break; default:reg=&r->hl;break;
    }
    if(write)*reg=value;
    return *reg;
}
void cry_resume(Capture*c){c->gb->halted=false;c->gb->stopped=false;c->gb->ime=true;}
