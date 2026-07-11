DelayFrame::
; Wait for one frame
	ld a, 1
	ld [wVBlankOccurred], a

; Wait for the next VBlank, halting to conserve battery
.halt
	halt ; rgbasm adds a nop after this instruction by default
	ld a, [wVBlankOccurred]
	and a
	jr nz, .halt
	ret

DelayFrames::
; Wait c frames
	call DelayFrame
	dec c
	jr nz, DelayFrames
	ret

WeatherDelayFrame::
; Wait one frame, keeping overworld weather particles animating.
	call UpdateWeatherSprites
	jp DelayFrame

WeatherDelayFrames::
; Wait c frames, keeping overworld weather particles animating.
; Used by the textbox paragraph/scroll pauses and BG map waits so
; weather doesn't visibly freeze during dialogue and menus.
	call WeatherDelayFrame
	dec c
	jr nz, WeatherDelayFrames
	ret
