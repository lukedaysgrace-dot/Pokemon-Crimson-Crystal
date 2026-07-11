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
; Wait one frame while allowing safe overworld weather redraws.
	call UpdateWeatherSprites
	jp DelayFrame

WeatherDelayFrames::
; Used for pauses within overworld text rendering. Full-screen interfaces
; disable overworld sprite updates, making UpdateWeatherSprites a no-op there.
	call WeatherDelayFrame
	dec c
	jr nz, WeatherDelayFrames
	ret
