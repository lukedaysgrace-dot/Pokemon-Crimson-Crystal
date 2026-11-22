_InitializeStartDay:
	call InitializeStartDay
	ret

ClearDailyTimers:
	xor a
	ld [wLuckyNumberDayBuffer], a
	ld [wUnusedTwoDayTimer], a
	ld [wDailyResetTimer], a
	ld [wWeatherRandomDay], a
	ld hl, wWeatherDailyFlags
	res WEATHER_DAILY_VALID_F, [hl]
	ret

InitCallReceiveDelay::
	xor a
	ld [wTimeCyclesSinceLastCall], a

NextCallReceiveDelay:
	ld a, [wTimeCyclesSinceLastCall]
	cp 3
	jr c, .okay
	ld a, 3

.okay
	ld e, a
	ld d, 0
	ld hl, .ReceiveCallDelays
	add hl, de
	ld a, [hl]
	jp RestartReceiveCallDelay

.ReceiveCallDelays:
	db 20, 10, 5, 3

CheckReceiveCallTimer:
	call CheckReceiveCallDelay ; check timer
	ret nc
	ld hl, wTimeCyclesSinceLastCall
	ld a, [hl]
	cp 3
	jr nc, .ok
	inc [hl]

.ok
	call NextCallReceiveDelay ; restart timer
	scf
	ret

InitOneDayCountdown:
	ld a, 1

InitNDaysCountdown:
	ld [hl], a
	push hl
	call UpdateTime
	pop hl
	inc hl
	call CopyDayToHL
	ret

CheckDayDependentEventHL:
	inc hl
	push hl
	call CalcDaysSince
	call GetDaysSince
	pop hl
	dec hl
	call UpdateTimeRemaining
	ret

RestartReceiveCallDelay:
	ld hl, wReceiveCallDelay_MinsRemaining
	ld [hl], a
	call UpdateTime
	ld hl, wReceiveCallDelay_StartTime
	call CopyDayHourMinToHL
	ret

CheckReceiveCallDelay:
	ld hl, wReceiveCallDelay_StartTime
	call CalcMinsHoursDaysSince
	call GetMinutesSinceIfLessThan60
	ld hl, wReceiveCallDelay_MinsRemaining
	call UpdateTimeRemaining
	ret

RestartDailyResetTimer:
	ld hl, wDailyResetTimer
	jp InitOneDayCountdown

CheckDailyResetTimer::
	ld hl, wDailyResetTimer
	call CheckDayDependentEventHL
	push af
	call UpdateShucksReserveStock
	pop af
	ret nc
	; Shucks' Friday show runs past midnight: the reset that first reaches
	; Saturday's overnight hours (one day after the last reset) keeps that
	; shift's state, and any other reset clears it.
	ld b, 0
	ld a, [wDaysSince]
	cp 1
	jr nz, .clear_shucks_shift
	ldh a, [hHours]
	cp MORN_HOUR
	jr nc, .clear_shucks_shift
	call GetWeekday
	cp SATURDAY ; the Friday shift's overnight hours
	jr nz, .clear_shucks_shift
	ld a, [wSwarmFlags]
	and SWARMFLAGS_SHUCKS_SHIFT_MASK
	ld b, a
.clear_shucks_shift
	xor a
	ld [wWeatherRandomDay], a
	ld hl, wWeatherDailyFlags
	res WEATHER_DAILY_VALID_F, [hl]
	ld hl, wDailyFlags1
	ld [hli], a ; wDailyFlags1
	ld [hli], a ; wDailyFlags2
	ld [hl], b  ; wSwarmFlags (only the Shucks shift bits survive)
	inc hl
	ld [hl], a  ; wFishingContestDailyFlags
	ld hl, wDailyRematchFlags
rept 4
	ld [hli], a
endr
	ld hl, wDailyPhoneItemFlags
rept 4
	ld [hli], a
endr
	ld hl, wDailyPhoneTimeOfDayFlags
rept 4
	ld [hli], a
endr
	ld hl, wKenjiBreakTimer
	ld a, [hl]
	and a
	jr z, .RestartKenjiBreakCountdown
	dec [hl]
	jr nz, .DontRestartKenjiBreakCountdown
.RestartKenjiBreakCountdown:
	call SampleKenjiBreakCountdown
.DontRestartKenjiBreakCountdown:
	jr RestartDailyResetTimer

UpdateShucksReserveStock:
	ld hl, wShucksReserveStock
	ld a, [hl]
	and a
	ret z
	cp SHUCKS_RESERVE_SOLD_LEGACY
	jr nz, .check_day
	; Older saves stored a calendar-day flag. Use the saved hour to place
	; that purchase in the evening or the previous night's overnight hours.
	ld a, [wRTC + 1]
	cp NITE_HOUR
	ld a, SHUCKS_RESERVE_SOLD_OVERNIGHT
	jr c, .migrate
	ld a, SHUCKS_RESERVE_SOLD_EVENING
.migrate
	ld [hl], a
.check_day
	ld a, [wDaysSince]
	and a
	jr z, .same_day
	dec a
	jr nz, .restock
	ldh a, [hHours]
	cp MORN_HOUR
	jr nc, .restock
	; The evening purchase still counts after midnight on the same shift.
	ld a, [hl]
	cp SHUCKS_RESERVE_SOLD_EVENING
	jr nz, .restock
	ld [hl], SHUCKS_RESERVE_SOLD_OVERNIGHT
	ret
.same_day
	ldh a, [hHours]
	cp MORN_HOUR
	ret c
	ld a, [hl]
	cp SHUCKS_RESERVE_SOLD_OVERNIGHT
	ret nz
.restock
	ld [hl], 0
	ret

SampleKenjiBreakCountdown:
; Generate a random number between 3 and 6
	call Random
	and %11
	add 3
	ld [wKenjiBreakTimer], a
	ret

StartBugContestTimer:
	ld a, BUG_CONTEST_MINUTES
	ld [wBugContestMinsRemaining], a
	ld a, BUG_CONTEST_SECONDS
	ld [wBugContestSecsRemaining], a
	call UpdateTime
	ld hl, wBugContestStartTime
	call CopyDayHourMinSecToHL
	ret

CheckBugContestTimer::
	ld hl, wBugContestStartTime
	call CalcSecsMinsHoursDaysSince
	ld a, [wDaysSince]
	and a
	jr nz, .timed_out
	ld a, [wHoursSince]
	and a
	jr nz, .timed_out
	ld a, [wSecondsSince]
	ld b, a
	ld a, [wBugContestSecsRemaining]
	sub b
	jr nc, .okay
	add 60

.okay
	ld [wBugContestSecsRemaining], a
	ld a, [wMinutesSince]
	ld b, a
	ld a, [wBugContestMinsRemaining]
	sbc b
	ld [wBugContestMinsRemaining], a
	jr c, .timed_out
	and a
	ret

.timed_out
	xor a
	ld [wBugContestMinsRemaining], a
	ld [wBugContestSecsRemaining], a
	scf
	ret

InitializeStartDay:
	call UpdateTime
	ld hl, wTimerEventStartDay
	call CopyDayToHL
	ret

CheckPokerusTick::
	ld hl, wTimerEventStartDay
	call CalcDaysSince
	call GetDaysSince
	and a
	jr z, .done ; not even a day has passed since game start
	ld b, a
	farcall ApplyPokerusTick
.done
	xor a
	ret

SetUnusedTwoDayTimer:
	ld a, 2
	ld hl, wUnusedTwoDayTimer
	ld [hl], a
	call UpdateTime
	ld hl, wUnusedTwoDayTimerStartDate
	call CopyDayToHL
	ret

CheckUnusedTwoDayTimer:
	ld hl, wUnusedTwoDayTimerStartDate
	call CalcDaysSince
	call GetDaysSince
	ld hl, wUnusedTwoDayTimer
	call UpdateTimeRemaining
	ret

; unused
	ld hl, wDailyFlags1
	set DAILYFLAGS1_FISH_SWARM_F, [hl]
	ret

; unused
	and a
	ld hl, wDailyFlags1
	bit DAILYFLAGS1_FISH_SWARM_F, [hl]
	ret nz
	scf
	ret

RestartLuckyNumberCountdown:
	call .GetDaysUntilNextFriday
	ld hl, wLuckyNumberDayBuffer
	jp InitNDaysCountdown

.GetDaysUntilNextFriday:
	call GetWeekday
	ld c, a
	ld a, FRIDAY
	sub c
	jr z, .friday_saturday
	jr nc, .earlier ; could have done "ret nc"

.friday_saturday
	add 7

.earlier
	ret

_CheckLuckyNumberShowFlag:
	ld hl, wLuckyNumberDayBuffer
	jp CheckDayDependentEventHL

DoMysteryGiftIfDayHasPassed:
	ld a, BANK(sMysteryGiftTimer)
	call GetSRAMBank
	ld hl, sMysteryGiftTimer
	ld a, [hli]
	ld [wBuffer1], a
	ld a, [hl]
	ld [wBuffer2], a
	call CloseSRAM

	ld hl, wBuffer1
	call CheckDayDependentEventHL
	jr nc, .not_timed_out
	ld hl, wBuffer1
	call InitOneDayCountdown
	call CloseSRAM
	farcall Function1050c8

.not_timed_out
	ld a, BANK(sMysteryGiftTimer)
	call GetSRAMBank
	ld hl, wBuffer1
	ld a, [hli]
	ld [sMysteryGiftTimer], a
	ld a, [hl]
	ld [sMysteryGiftTimer + 1], a
	call CloseSRAM
	ret

UpdateTimeRemaining:
; If the amount of time elapsed exceeds the capacity of its
; unit, skip this part.
	cp -1
	jr z, .set_carry
	ld c, a
	ld a, [hl] ; time remaining
	sub c
	jr nc, .ok
	xor a

.ok
	ld [hl], a
	jr z, .set_carry
	xor a
	ret

.set_carry
	xor a
	ld [hl], a
	scf
	ret

GetSecondsSinceIfLessThan60:
	ld a, [wDaysSince]
	and a
	jr nz, GetTimeElapsed_ExceedsUnitLimit
	ld a, [wHoursSince]
	and a
	jr nz, GetTimeElapsed_ExceedsUnitLimit
	ld a, [wMinutesSince]
	and a
	jr nz, GetTimeElapsed_ExceedsUnitLimit
	ld a, [wSecondsSince]
	ret

GetMinutesSinceIfLessThan60:
	ld a, [wDaysSince]
	and a
	jr nz, GetTimeElapsed_ExceedsUnitLimit
	ld a, [wHoursSince]
	and a
	jr nz, GetTimeElapsed_ExceedsUnitLimit
	ld a, [wMinutesSince]
	ret

GetHoursSinceIfLessThan24:
	ld a, [wDaysSince]
	and a
	jr nz, GetTimeElapsed_ExceedsUnitLimit
	ld a, [wHoursSince]
	ret

GetDaysSince:
	ld a, [wDaysSince]
	ret

GetTimeElapsed_ExceedsUnitLimit:
	ld a, -1
	ret

CalcDaysSince:
	xor a
	jr _CalcDaysSince

CalcHoursDaysSince:
	inc hl
	xor a
	jr _CalcHoursDaysSince

CalcMinsHoursDaysSince:
	inc hl
	inc hl
	xor a
	jr _CalcMinsHoursDaysSince

CalcSecsMinsHoursDaysSince:
	inc hl
	inc hl
	inc hl
	ldh a, [hSeconds]
	ld c, a
	sub [hl]
	jr nc, .skip
	add 60
.skip
	ld [hl], c ; current seconds
	dec hl
	ld [wSecondsSince], a ; seconds since

_CalcMinsHoursDaysSince:
	ldh a, [hMinutes]
	ld c, a
	sbc [hl]
	jr nc, .skip
	add 60
.skip
	ld [hl], c ; current minutes
	dec hl
	ld [wMinutesSince], a ; minutes since

_CalcHoursDaysSince:
	ldh a, [hHours]
	ld c, a
	sbc [hl]
	jr nc, .skip
	add 24
.skip
	ld [hl], c ; current hours
	dec hl
	ld [wHoursSince], a ; hours since

_CalcDaysSince:
	ld a, [wCurDay]
	ld c, a
	sbc [hl]
	jr nc, .skip
	add 20 * 7
.skip
	ld [hl], c ; current days
	ld [wDaysSince], a ; days since
	ret

CopyDayHourMinSecToHL:
	ld a, [wCurDay]
	ld [hli], a
	ldh a, [hHours]
	ld [hli], a
	ldh a, [hMinutes]
	ld [hli], a
	ldh a, [hSeconds]
	ld [hli], a
	ret

CopyDayToHL:
	ld a, [wCurDay]
	ld [hl], a
	ret

CopyDayHourToHL:
	ld a, [wCurDay]
	ld [hli], a
	ldh a, [hHours]
	ld [hli], a
	ret

CopyDayHourMinToHL:
	ld a, [wCurDay]
	ld [hli], a
	ldh a, [hHours]
	ld [hli], a
	ldh a, [hMinutes]
	ld [hli], a
	ret
